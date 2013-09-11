root = exports ? this

root.Indexer = class Indexer

  elasticsearch = Meteor.require('elasticsearch')
  settings = Meteor.settings.public['elastic-search']
  priv = Meteor.settings['elastic-search']
  if settings
    console.log('Will connect to ES at ' + settings.host + ':' + settings.port + '  Using index: ' + settings.index)
    conf =
      _index: settings.index
      _type: 'technology'
      server:
        host: settings.host
        port: settings.port
    if priv.auth then conf.server.auth = priv.auth
    technologies = elasticsearch(conf)

  indexTechnology: (techData) ->
    techData = @prepare(techData)
    Meteor.sync((done) ->
      technologies.index({_id: techData._id}, techData, (err, data) ->
        if err
          console.error(err)
          done(err)
        else
          console.log("Index success. " + data)
          done(null, data)
      )
    )

  removeTechnology: (techId) ->
    Meteor.sync((done) ->
      technologies.delete({_id: techId}, (err, data) ->
        if err
          console.error(err)
          done(err)
        else
          console.log("Delete success. " + data)
          done(null, data)
      )
    )

  # Prepares the document for indexing
  prepare: (techData) ->
    @extractTags(techData)

  # digs into the techData and pulls the tags up so they are easily indexed
  # and more naturally used while searching
  extractTags: (techData) ->
    tags = []
    for aspect in techData.aspects
      if aspect.defId == 'vertical' or aspect.defId == 'stack'
        for contribution in aspect.contributions
          for tag in contribution.tags
            tags.push("#{aspect.defId}:#{tag}")
    if tags
      tags = _.uniq(tags)
      techData = _.extend({}, techData)
      techData.tags = tags
    techData


root.indexer = new Indexer()
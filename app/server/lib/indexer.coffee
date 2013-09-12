root = exports ? this

class Indexer

  elasticsearch = Meteor.require('elasticsearch')
  settings = Meteor.settings.public['elastic-search']
  priv = Meteor.settings['elastic-search']
  suggestEnabled = settings['suggest-enabled']
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


  init: ->
    @mapTechnologies()

  # Initializes the technology document mapping
  mapTechnologies: ->
    options = {}
    mapping =
      technology:
        properties:
          aspects:
            properties:
              aspectId:
                type: "string"
              contributions:
                properties:
                  content:
                    type: "string"
                  contributionId:
                    type: "string"
                  contributorId:
                    type: "string"
                  createdAt:
                    type: "date",
                    format: "dateOptionalTime"
                  deletedAt:
                    type: "date",
                    format: "dateOptionalTime"
                  updatedAt:
                    type: "date",
                    format: "dateOptionalTime"
              defId:
                type: "string"
              name:
                type: "string"
              type:
                type: "string"
          contributorId:
            type: "string"
          createdAt:
            type: "date",
            format: "dateOptionalTime"
          name:
            type: "string"
          tags:
            properties:
              stack:
                type: "string"
              vertical:
                type: "string"
          updatedAt:
            type: "date",
            format: "dateOptionalTime"
          usedBy:
            type: "string"

    if suggestEnabled
      mapping.technology.properties.tags_suggest =
        type: "object"
        properties:
          vertical:
            type: "completion"
          stack:
            type: "completion"

    Meteor.sync((done) ->
      technologies.indices.putMapping(options, mapping, (err, data) ->
        if err
          console.log(err)
          done(err)
        else
          console.log('Mapping success. ' + data)
          done(null, data)
      )
    )

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
  prepare: (doc) ->
    doc = _.extend({}, doc)
    @removeDeleted(doc)
    @extractTags(doc)
    if suggestEnabled
      @extractSuggestionTags(doc)
    @refactorUsedBy(doc)
    doc

  # Removes aspects marked as deletedAt (or entire documents marked as so)
  removeDeleted: (doc) ->
    if doc.deletedAt
      delete doc.name
      delete doc.aspects
      delete doc.contributorId
      delete doc.usedBy
      return
    for aspect in doc.aspects
      newContributions = []
      for contribution in aspect.contributions
        if not contribution.deletedAt
          newContributions.push contribution
      aspect.contributions = newContributions

  # Refactors the usedBy map {userId: boolean} into an array [userId1, userId2]
  refactorUsedBy: (doc) ->
    doc.usedBy = (userId for userId, used of doc.usedBy when used)

  # digs into the techData and pulls the tags up so they are easily indexed
  # and more naturally used while searching
  extractTags: (doc) ->
    tags = {}
    defs = ['vertical', 'stack']
    for d in defs
      tags[d] = []
    for aspect in doc.aspects
      if aspect.defId in defs
        for contribution in aspect.contributions
          for tag in contribution.tags
            if tag
              tags[aspect.defId].push(tag)
          delete contribution.tags
    for d in defs
      tags[d] = _.uniq(tags[d])
    doc.tags = tags

  extractSuggestionTags: (doc) ->
    doc.tags_suggest = _.extend({}, doc.tags)

root.indexer = new Indexer()
root.indexer.init()

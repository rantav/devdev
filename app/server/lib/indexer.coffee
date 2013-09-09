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

  # Readonly URLs are something like this: https://api.searchbox.io/api-key/vvuzat0lcbcoq4ltmdzqixhfoeesfj8b/dev_devdev/technology/zwWmbAh44fjvAaNBy
  # Where vvuzat0lcbcoq4ltmdzqixhfoeesfj8b is at Meteor.settings.public['elastic-search']['access-key']
  indexTechnology: (techData) ->
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

root.indexer = new Indexer()
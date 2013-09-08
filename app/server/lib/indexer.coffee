root = exports ? this

root.Indexer = class Indexer

  elasticsearch = Meteor.require('elasticsearch')
  if Meteor.settings['elastic-search']
    host = Meteor.settings['elastic-search']['host']
    port = Meteor.settings['elastic-search']['port']
    auth = Meteor.settings['elastic-search']['auth']
    indexName = Meteor.settings['elastic-search']['index']
    console.log('Will connect to ES at ' + host + '  Using index: ' + indexName)
    technologies = elasticsearch
      _index: indexName
      _type: 'technology'
      server:
        host: host
        port: port
        auth: auth

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

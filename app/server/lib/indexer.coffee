root = exports ? this

root.Indexer = class Indexer

  elasticsearch = Meteor.require('elasticsearch')

  technologies = elasticsearch
    _index: 'technologies'
    _type: 'technology'

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

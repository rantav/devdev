elasticsearch = Meteor.require('elasticsearch')

technologies = elasticsearch
  _index: 'technologies'
  _type: 'technology'

Meteor.methods
  indexTechnology: (technologyId) ->
    technology = Technology.findOne(technologyId)
    response = Meteor.sync((done) ->
      technologies.index({_id: technology.id()}, technology.data, (err, data) ->
        if err
          console.error(err)
          done(err)
        else
          console.log("Index success. " + data)
          done(null, data)
      )
    )
    if response.error then throw new Meteor.Error 500, JSON.stringify(response.error)
    response.result

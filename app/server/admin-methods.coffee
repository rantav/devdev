elasticsearch = Meteor.require('elasticsearch')

technologies = elasticsearch
  _index: 'technologies'
  _type: 'technology'

Meteor.methods
  indexTechnology: (technologyId) ->
    technology = Technology.findOne(technologyId)
    ret = null
    error = null
    Meteor.sync((done) ->
      technologies.index({_id: technology.id()}, technology.data, (err, data) ->
        if err
          console.error(err)
          error = err
        else
          ret = data
          console.log("Index success. " + data)
        done()
      )
    )
    if error then throw new Meteor.Error 500, JSON.stringify(error)
    ret

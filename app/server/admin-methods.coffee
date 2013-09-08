elasticsearch = Meteor.require('elasticsearch')

technologies = elasticsearch
  _index: 'technologies'
  _type: 'technology'

Meteor.methods
  indexTechnology: (technologyId) ->
    user = Contributor.current()
    if not user.isAdmin()
      throw new Meteor.Error 401, "Sorry, only admins can do that..."
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

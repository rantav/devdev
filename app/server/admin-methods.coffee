Meteor.methods
  indexTechnology: (technologyId) ->
    user = User.current()
    if not user.isAdmin()
      throw new Meteor.Error 401, "Sorry, only admins can do that..."
    technology = Technology.findOne(technologyId)
    response = indexer.indexTechnology(technology.data)
    if response.error then throw new Meteor.Error 500, JSON.stringify(response.error)
    response.result

  indexAllTechnologies: ->
    user = Contributor.current()
    if not user.isAdmin()
      throw new Meteor.Error 401, "Sorry, only admins can do that..."
    technologies = (t for t in Technologies.find({deletedAt: {$exists: false}}).fetch())
    response = indexer.bulkIndexTechnologies(technologies)
    if response.error then throw new Meteor.Error 500, JSON.stringify(response.error)
    response.result
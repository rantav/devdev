
Meteor.methods
  createNewTechnology: (technologyName) ->
    contributor = Contributor.current()
    if not contributor
      throw new Meteor.Error 404, 'Please log in'

    technology = Technology.create technologyName
    contributor.addTechnologyContribution technology
    technology.data

  contributeToAspect: (technologyId, aspectId, contributionText) ->
    contributor = Contributor.current()
    if not contributor
      throw new Meteor.Error 404, 'Please log in'

    if technologyId and aspectId and contributionText
      technology = Technology.find(technologyId)
      aspect = technology.findAspectById(aspectId)
      aspectContribution = aspect.addContribution(contributionText)
      contributor.addAspectContribution(aspectContribution)
      aspectContribution.data

  toggleContributingAspect: (technologyId, aspectId) ->
    technology = Technology.find(technologyId)
    aspect = technology.findAspectById(aspectId)
    aspect.toggleEditCurrentUser()

  endContributingAspect: (technologyId, aspectId) ->
    technology = Technology.find(technologyId)
    aspect = technology.findAspectById(aspectId)
    aspect.setEditCurrentUser(false)

  deleteAspectContribution: (technologyId, contributionId) ->
    technology = Technology.find(technologyId)
    aspectContribution = technology.findContributionById(contributionId)

    if not aspectContribution.isCurrentUserOwner()
      throw new Meteor.Error 404, 'Sorry, you cannot delete someone else\'s contribution'

    contributor = aspectContribution.contributor()
    aspectContribution.delete()
    contributor.deleteAspectContribution(aspectContribution)

  deleteTechnology: (technologyId) ->
    technology = Technology.find(technologyId)
    # Permission check
    if not technology.isCurrentUserOwner()
      throw new Meteor.Error 404, 'Sorry, you cannot delete someone else\'s contribution'

    contributor = technology.owner()
    technology.delete()
    contributor.deleteTechnologyContribution(technology)

  setName: (technologyId, newName) ->
    technology = Technology.find(technologyId)
    # Permission check
    if not technology.isCurrentUserOwner()
      throw new Meteor.Error 404, 'Sorry, you cannot change the name of technology not created by you'
    technology.setName(newName)

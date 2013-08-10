
Meteor.methods
  createNewTechnology: (technologyName) ->
    contributor = Contributor.current()
    if not contributor
      throw new Meteor.Error 404, 'Please log in'

    technology = Technology.create(technologyName)
    contributor.addTechnologyContribution(technology)
    technology.data

  contributeToAspect: (technologyId, aspectId, contributionText) ->
    contributor = Contributor.current()
    if not contributor
      throw new Meteor.Error 404, 'Please log in'

    if technologyId and aspectId and contributionText
      technology = Technology.findOne(technologyId)
      aspect = technology.findAspectById(aspectId)
      aspectContribution = aspect.addContribution(contributionText)
      contributor.addAspectContribution(aspectContribution)
      aspectContribution.data

  contributeNewAspect: (technologyId, aspectName, aspectTextValue) ->
    contributor = Contributor.current()
    if not contributor
      throw new Meteor.Error 404, 'Please log in'
    technology = Technology.findOne(technologyId)
    aspectContribution = technology.addAspectAndContribution(aspectName, aspectTextValue)
    contributor.addAspectContribution(aspectContribution)
    aspectContribution.data

  deleteAspectContribution: (technologyId, contributionId) ->
    technology = Technology.findOne(technologyId)
    aspectContribution = technology.findContributionById(contributionId)

    if not aspectContribution.isCurrentUserOwner()
      throw new Meteor.Error 404, 'Sorry, you cannot delete someone else\'s contribution'

    contributor = aspectContribution.contributor()
    aspectContribution.delete()
    contributor.deleteAspectContribution(aspectContribution)

  deleteTechnology: (technologyId) ->
    technology = Technology.findOne(technologyId)
    # Permission check
    if not technology.isCurrentUserOwner()
      throw new Meteor.Error 404, 'Sorry, you cannot delete someone else\'s contribution'

    contributor = technology.owner()
    technology.delete()
    contributor.deleteTechnologyContribution(technology)

  setName: (technologyId, newName) ->
    technology = Technology.findOne(technologyId)
    # Permission check
    if not technology.isCurrentUserOwner()
      throw new Meteor.Error 404, 'Sorry, you cannot change the name of technology not created by you'
    technology.setName(newName)


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
    contributor.deleteContribution(aspectContribution)
    # now = new Date()
    # # Delete contribution
    # contribution.deletedAt = now
    # Technologies.update(technologyId, technology)
    # # Delete from the users's registry
    # contributor = Meteor.user()
    # userContribution = Contributors.findAspectContribution(contributor, contributionId)
    # userContribution.deletedAt = now
    # Meteor.users.update(contributor._id, contributor)

  deleteTechnology: (technologyId) ->
    technology = Technologies.findOne(technologyId)
    # Permission check
    if technology.contributorId == Meteor.userId()
      now = new Date()
      technology.deletedAt = now
      Technologies.update(technologyId, technology)
      # Delete from the users's registry
      contributor = Meteor.user()
      technologyContributions = Contributors.findTechnologyContributions(contributor, technologyId)
      contrib.deletedAt = now for contrib in technologyContributions
      Meteor.users.update(contributor._id, contributor)
    else
      throw new Meteor.Error 404, 'Sorry, you cannot delete someone else\'s contribution'

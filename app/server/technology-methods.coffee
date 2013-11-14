
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
      if not technology
        throw new Meteor.Error 401, "Technology #{technologyId} was not found"
      aspect = technology.findAspectById(aspectId)
      aspectContribution = aspect.addContribution(contributionText, contributor)
      contributor.addAspectContribution(aspectContribution)
      aspectContribution.data

  contributeNewAspect: (technologyId, aspectName, aspectTextValue, aspectDef) ->
    contributor = Contributor.current()
    if not contributor
      throw new Meteor.Error 404, 'Please log in'
    technology = Technology.findOne(technologyId)
    if not technology
      throw new Meteor.Error 401, "Technology #{technologyId} was not found"
    aspectContribution = technology.addAspectAndContribution(aspectName, aspectTextValue, aspectDef, contributor)
    contributor.addAspectContribution(aspectContribution)
    aspectContribution.data

  deleteAspectContribution: (technologyId, contributionId) ->
    technology = Technology.findOne(technologyId)
    if not technology
      throw new Meteor.Error 401, "Technology #{technologyId} was not found"
    aspectContribution = technology.findContributionById(contributionId)

    if not aspectContribution.isCurrentUserOwner()
      throw new Meteor.Error 404, 'Sorry, you cannot delete someone else\'s contribution'

    contributor = aspectContribution.contributor()
    aspectContribution.delete()
    contributor.deleteAspectContribution(aspectContribution)

  deleteTechnology: (technologyId) ->
    technology = Technology.findOne(technologyId)
    if not technology
      throw new Meteor.Error 401, "Technology #{technologyId} was not found"
    # Permission check
    if not technology.isCurrentUserOwner()
      throw new Meteor.Error 404, 'Sorry, you cannot delete someone else\'s contribution'

    contributor = technology.owner()
    technology.delete()

  setName: (technologyId, newName) ->
    technology = Technology.findOne(technologyId)
    if not technology
      throw new Meteor.Error 401, "Technology #{technologyId} was not found"
    # Permission check
    if not technology.isCurrentUserOwner()
      throw new Meteor.Error 404, 'Sorry, you cannot change the name of technology not created by you'
    technology.setName(newName)

  # Marks the technology as used by the current user.
  # used:boolean true to mean that it's used, false to mean that it isn't
  iUseIt: (toolId, used) ->
    contributor = Contributor.current()
    if not contributor
      throw new Meteor.Error 404, 'Please log in'
    tool = Tool.findOne(toolId)
    if not tool
      throw new Meteor.Error 401, "Tool #{toolId} was not found"
    contributor.setUsingTechnology(tool, used)

Template.contributor.contributor = ->
  contributor = Meteor.users.findOne Session.get('contributorId')
  if not contributor
    contributor = Meteor.users.findOne({'profile.name': Session.get('contributorId')})
  contributor

Template.contributor.getTechnology = (technologyId) ->
  Technologies.findOne technologyId

Template.contributor.getAspect = (technology, aspectId) ->
  Technologies.findAspectById(technology, aspectId)

Template.contributor.getContributionData = (aspect, contributionId) ->
  Technologies.findContributionInAspect(aspect, contributionId)

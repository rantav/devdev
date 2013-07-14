Template.contributor.contributor = ->
  contributor = Meteor.users.findOne Session.get('contributorId')
  if not contributor
    contributor = Meteor.users.findOne({'profile.name': Session.get('contributorId')})
  contributor

Template.contributor.contributions = ->
  contributor = Template.contributor.contributor()
  Contributors.getContributions(contributor)

Template.contributor.getTechnology = (technologyId) ->
  Technologies.findOne technologyId

Template.contributor.getAspect = (technology, aspectId) ->
  Technologies.findAspectById(technology, aspectId)

Template.contributor.getContributionData = (aspect, contributionId) ->
  Technologies.findContributionInAspect(aspect, contributionId)

Template.contributor.events
  'click .disabled': ->
    alertify.log '<strong>Coming soonish...</strong> <i class="icon-cogs pull-right"> </i>'

Template.contributor.contributor = ->
  contributorData = Meteor.users.findOne Session.get('contributorId')
  if not contributorData
    contributorData = Meteor.users.findOne({'profile.name': Session.get('contributorId')})
  new Contributor(contributorData)

Template.contributor.events
  'click .disabled': ->
    alertify.log '<strong>Coming soonish...</strong> <i class="icon-cogs pull-right"> </i>'

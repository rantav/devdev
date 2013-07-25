Template.contributor.contributor = ->
  contributorData = Meteor.users.findOne Session.get('contributorId')
  if not contributorData
    contributorData = Meteor.users.findOne({'profile.name': Session.get('contributorId')})
  contributor = new Contributor(contributorData)
  document.title = "#{contributor.name()} | devdev.io"
  contributor

Template.contributor.events
  'click .disabled': ->
    alertify.log '<strong>Coming soonish...</strong> <i class="icon-cogs pull-right"> </i>'

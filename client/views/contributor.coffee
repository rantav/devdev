Template.contributor.contributor = ->
  contributor = Meteor.users.findOne Session.get('contributorId')
  if not contributor
    contributor = Meteor.users.findOne({'profile.name': Session.get('contributorId')})
  contributor

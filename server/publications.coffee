Meteor.publish "technologies", ->
  Technologies.find() # TODO: filter out deleted technologies

Meteor.publish "users", ->
  Meteor.users.find {},
    fields:
      profile: 1
      'services.google.picture': 1

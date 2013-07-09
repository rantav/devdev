Meteor.publish "technologies", ->
  Technologies.find
    deletedAt:
      $exists: false

Meteor.publish "users", ->
  Meteor.users.find {},
    fields:
      profile: 1
      'services.google.picture': 1

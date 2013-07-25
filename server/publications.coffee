Meteor.publish "technologies", ->
  Technologies.find
    deletedAt:
      $exists: false

Meteor.publish "technologies-deleted", ->
  Technologies.find {
    deletedAt:
      $exists: true
  },
  fields:
    name: 1
    deletedAt: 1

Meteor.publish "users", ->
  Meteor.users.find {},
    fields:
      profile: 1
      'services.google.picture': 1
      'services.github.picture': 1 # This one's prepopulated at Accounts.onCreateUser since github by default does not add the picture (avatar) url

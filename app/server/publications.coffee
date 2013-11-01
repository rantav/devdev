Meteor.publish "technologies", ->
  Technology._collection.find {
    deletedAt:
      $exists: false
  }

Meteor.publish "technologiesDeleted", ->
  Technology._collection.find {
    deletedAt:
      $exists: true
  },
  fields:
    name: 1
    deletedAt: 1

Meteor.publish "contributors", ->
  Meteor.users.find {},
    fields:
      contributions: 1
      profile: 1
      'services.google.picture': 1
      'services.github.picture': 1 # This one's prepopulated at Accounts.onCreateUser since github by default does not add the picture (avatar) url

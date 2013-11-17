Meteor.publish "tools", ->
  Tool._collection.find
    deletedAt:
      $exists: false

Meteor.publish "tool", (id) ->
  check(id, String)
  pubs = [Tool._collection.find({_id: id})]
  if t = Tool.findOne(id)
    pubs.push(t.usedBy(fields: userFields));
  pubs

Meteor.publish "toolsDeleted", ->
  Tool.find {
    deletedAt:
      $exists: true
  },
  fields:
    name: 1
    deletedAt: 1

userFields =
  profile: 1
  'services.google.picture': 1
  'services.github.picture': 1 # This one's prepopulated at Accounts.onCreateUser since github by default does not add the picture (avatar) url

Meteor.publish "users", ->
  Meteor.users.find {},
    fields: userFields

Meteor.publish "user", (id)->
  check(id, String)
  pubs = [Meteor.users.find({_id: id}, fields: userFields)]
  if u = User.findOneUser(id)
    pubs.push(u.usedTools());
  pubs

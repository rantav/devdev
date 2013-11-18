notDeleted = {deletedAt: $exists: false}

Meteor.publish "tools", (options) ->
  pubs = []
  # Publish the tools
  pubs.push(Tool._collection.find(notDeleted, options))
  # As well as the related users
  userIds = []
  Tool._collection.find(notDeleted, _.extend({transform: null, fields: {usedBy: 1}}, options)).forEach((t) ->
    userIds = _.union(userIds, (userId for userId, used of t.usedBy when used))
  )
  if userIds.length
    pubs.push(Meteor.users.find({$or: userIds}, {fields: userFields}))
  pubs

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

Meteor.publish "users", (options) ->
  pubs = []
  # Publish the users
  pubs.push(Meteor.users.find {}, _.extend({fields: userFields}, options))
  # And the tools that those users use
  toolIds = []
  Meteor.users.find({}, _.extend({fields: {'profile.usingTool': 1}}, options)).forEach((u) ->
    toolIds = _.union(toolIds, (toolId for toolId, used of u.profile.usingTool when used))
  )
  if toolIds.length
    pubs.push(Tool._collection.find(_.extend({$or: toolIds}, notDeleted)))
  pubs

Meteor.publish "user", (id)->
  check(id, String)
  pubs = [Meteor.users.find({_id: id}, fields: userFields)]
  if u = User.findOneUser(id)
    pubs.push(u.usedTools());
  pubs

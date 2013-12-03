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
  pubs = []
  toolIds = [id]
  if not t = Tool.findOne(id) then return
  usedBy = t.usedBy(fields: userFields)
  pubs.push(usedBy) if usedBy
  if @userId
    # Publish projects (and their tools) with the currently logged in user,
    # or that contain this tool
    projects = Project.findByUserIdOrTool(@userId, id)
  else
    # Collect projects (and their tools) that contain this tool
    projects = t.projects()
  if projects
    pubs.push(projects)
    projects.forEach (p) ->
      tools = p.tools({}, {fields: {_id: 1}, transform: null})
      suggestedTools = p.suggestedTools({}, {fields: {_id: 1}, transform: null})
      toolIds = _.union(toolIds, tools.map((t) -> t._id), suggestedTools.map((t) -> t._id))

  pubs.push(Tool._collection.find($or: toolIds.map((tid) -> _id: tid)))
  pubs

Meteor.publish "toolsDeleted", ->
  Tool.find {
    deletedAt:
      $exists: true
  },
  fields:
    name: 1
    deletedAt: 1

Meteor.publish "toolNames", ->
  Tool.find(notDeleted, fields: name: 1, logo: 1)

Meteor.publish "projects", ->
  Project.find(notDeleted)

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

Meteor.publish "user", (id) ->
  check(id, String)
  pubs = [Meteor.users.find({_id: id}, fields: userFields)]
  if u = User.findOneUser(id)
    tools = u.usedTools()
    pubs.push(tools) if tools
    projects = u.projects(transform: null)
    pubs.push(projects) if projects
  pubs

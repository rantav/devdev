class @Project extends Model
  transform = (data) -> new Project(data)
  @_collection: new Meteor.Collection('projects', transform: transform)
  @_collection_del: new Meteor.Collection('projects_del', transform: transform)

  @findOne: (idOrName) ->
    super({$or: [{_id: idOrName}, {'name': new RegExp('^' + idOrName + '$', 'i')}]})

  @findByUserId: (userId, options) ->
    pred = {}
    pred["users.#{userId}"] = true
    @find(pred, options)

  @findByToolId: (toolId, options) ->
    pred = {}
    pred["tools.#{toolId}"] = true
    @find(pred, options)

  @findByUserIdAndTool: (userId, toolId, options) ->
    pred = {$and: [{},{}]}
    pred.$and[0]["users.#{userId}"] = true
    pred.$and[1]["tools.#{toolId}"] = true
    @find(pred, options)

  @findByUserIdOrTool: (userId, toolId, options) ->
    pred = {$or: [{},{}]}
    pred.$or[0]["users.#{userId}"] = true
    pred.$or[1]["tools.#{toolId}"] = true
    @find(pred, options)

  @new: (name, user) ->
    data =
      name: name
      creatorId: user.id()
      users: {}
      tools: {}
    data.users[user.id()] = true # The creating user is by default a member of the project
    new Project(data)

  @create: (name, user) ->
    if not user then return
    now = new Date()
    data = @new(name, user).data
    data.createdAt = now
    data.updatedAt = now
    id = @_collection.insert(data)
    @findOne(id)

  constructor: (data) ->
    super(data)
    @_users = new MinimongoidHashBooleanSet(Project._collection, data, 'users')
    @_tools = new MinimongoidHashBooleanSet(Project._collection, data, 'tools')
    @_suggestedTools = new MinimongoidHashBooleanSet(Project._collection, data, 'suggestedTools')
    @fetchingSuggestionsDep = new Deps.Dependency

  name: -> @data.name
  id: -> @data._id
  createdAt: -> @data.createdAt
  updatedAt: -> @data.updatedAt
  deletedAt: -> @data.deletedAt
  creator: -> User.findOneUser(@data.creatorId)
  githubUrl: -> @data.githubUrl
  hasGithubUrl: -> !!@data.githubUrl

  suggestedTools: (q, options) ->
    ret = @toolsByIds(@_suggestedTools.elements(), q, options)
    ret.forEach (t) -> t.suggested = true
    ret
  addSuggestedTools: (tools) ->
    for t in tools
      @setSuggestedTool(t, true)
  clearSuggestedTools: -> @_suggestedTools.clear()
  setSuggestedTool: (tool, isSuggested) -> @_suggestedTools.update(tool, isSuggested)
  hasSuggestedTools: -> not @_suggestedTools.isEmpty()

  fetchingSuggestions: ->
    @fetchingSuggestionsDep.depend()
    @_fetchingSuggestions
  setFetchingSuggestions: (val) ->
    @fetchingSuggestions = val
    @fetchingSuggestionsDep.changed()

  hasUser: (user) -> @_users.has(user)
  users: (q, options) ->
    elems = @_users.elements()
    if elems and elems.length
      User.findUsers(_.extend({$or: elems.map((id)->{_id: id})}, q), options)
  setUserMembership: (user, isMember) -> @_users.update(user, isMember)

  hasTool: (tool) -> @_tools.has(tool)
  tools: (q, options) -> @toolsByIds(@_tools.elements(), q, options)

  toolsByIds: (toolIds, q, options) ->
    if not toolIds or not toolIds.length then return []
    ts = Tool.find(_.extend({$or: toolIds.map((id)->{_id: id})}, q), options)
    currentProject = @
    ts = ts.map (t) ->
      t.currentProject = currentProject
      t
    ts

  setToolUsage: (tool, isUsed) -> @_tools.update(tool, isUsed)

  addUserAndTools: (user, tool1, tool2) ->
    @setToolUsage(tool1, true)
    @setToolUsage(tool2, true)
    @setUserMembership(user, true)

  isCurrentUserOwner: -> @data.creatorId == Meteor.userId()

  nameEditableByCurrentUser: -> @isCurrentUserOwner()

  rename: (name) ->
    if name == @name() then return
    Project._collection.update({_id: @id()}, {$set: {name: name}})

  setGithubUrl: (url) ->
    Project._collection.update({_id: @id()}, {$set: {githubUrl: url}})

  delete: ->
    Project._collection_del.insert(@data)
    Project._collection.remove({_id: @id()})

Project._collection.allow
  insert: (userId, doc) ->
    # the user must be logged in, and the document must be owned by the user
    userId and doc.data.creatorId == userId

  update: (userId, doc, fields, modifier) ->
    # can only change your own documents for now
    if doc.data.creatorId == userId then return true

  remove: (userId, doc) ->
    # the user must be logged in, and the document must be owned by the user
    userId and doc.data.creatorId == userId


  fetch: ['creatorId']

Project._collection_del.allow
  insert: (userId, doc) ->
    # the user must be logged in, and the document must be owned by the user
    userId and doc.data.creatorId == userId

  fetch: ['creatorId']


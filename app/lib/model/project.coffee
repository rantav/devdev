class @Project extends Model
  transform = (data) -> new Project(data)
  @_collection: new Meteor.Collection('projects', transform: transform)

  @findOne: (idOrName) ->
    super({$or: [{_id: idOrName}, {'name': new RegExp('^' + idOrName + '$', 'i')}]})

  @findByUserId: (userId, options) ->
    pred = {}
    pred["users.#{userId}"] = true
    @find(pred, options)

  @findByUserIdAndTool: (userId, toolId, options) ->
    pred = {$and: [{},{}]}
    pred.$and[0]["users.#{userId}"] = true
    pred.$and[1]["tools.#{toolId}"] = true
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

  name: -> @data.name
  id: -> @data._id
  createdAt: -> @data.createdAt
  updatedAt: -> @data.updatedAt
  deletedAt: -> @data.deletedAt
  creator: -> User.findOneUser(@data.creatorId)

  hasUser: (user) -> @_users.has(user)
  users: (q, options) ->
    elems = @_users.elements()
    if elems and elems.length
      User.findUsers(_.extend({$or: elems.map((id)->{_id: id})}, q), options)
  setUserMembership: (user, isMember) -> @_users.update(user.id(), isMember) if user

  hasTool: (tool) -> @_tools.has(tool)
  tools: (q, options) ->
    elems = @_tools.elements()
    if not elems or not elems.length then return []
    Tool.find(_.extend({$or: elems.map((id)->{_id: id})}, q), options)
  setToolUsage: (tool, isUsed) -> @_tools.update(tool.id(), isUsed) if tool

  addUserAndTools: (user, tool1, tool2) ->
    @setToolUsage(tool1, true)
    @setToolUsage(tool2, true)
    @setUserMembership(user, true)

  isCurrentUserOwner: -> @data.creatorId == Meteor.userId()

  nameEditableByCurrentUser: -> @isCurrentUserOwner()

  rename: (name) ->
    if name == @name() then return
    @_collection.update({_id: @id()}, {$set: {name: name}})

  delete: ->
    @_collection.update({_id: @id()}, {$set: {deletedAt: new Date()}})

Project._collection.allow
  insert: (userId, doc) ->
    # the user must be logged in, and the document must be owned by the user
    userId and doc.data.creatorId == userId

  update: (userId, doc, fields, modifier) ->
    # can only change your own documents for now
    if doc.data.creatorId == userId then return true


  fetch: ['creatorId']


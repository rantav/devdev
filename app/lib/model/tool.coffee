class @Tool extends Model
  @_collection: new Meteor.Collection('tools', transform: (data) => @modelize(data))
  @modelize: (data) -> new Tool(data)

  @findOne: (idOrName) ->
    super({$or: [{_id: idOrName}, {'name': new RegExp('^' + idOrName + '$', 'i')}]})

  @create: (name, user) ->
    if not name or not user then return
    now = new Date()
    data =
      name: name
      creatorId: user.id()
      createdAt: now
      updatedAt: now
      usedBy: {}
    id = @_collection.insert(data)
    @findOne(id)

  constructor: (data) ->
    super(data)
    @_usedBy = new MinimongoidHashBooleanSet(Tool._collection, data, 'usedBy')


  name: -> @data.name
  id: -> @data._id
  createdAt: -> @data.createdAt
  updatedAt: -> @data.updatedAt
  deletedAt: -> @data.deletedAt
  creator: -> User.findOneUser(@data.creatorId)

  route: -> Router.path('tool', id: @id(), name: @name())

  logoUrl: (options) ->
    logo = @data.logo
    if not logo then return options.default
    Url.imageUrl(logo, options)

  isUsedBy: (user) -> @_usedBy.has(user.id()) if user

  usedBy: ->
    User.findOneUser(e) for e in @_usedBy.elements()

  setUsedBy: (user, used) -> @_usedBy.update(user.id(), used) if user

Tool._collection.allow
  insert: (userId, doc) ->
    # the user must be logged in, and the document must be owned by the user
    userId and doc.data.creatorId == userId

  update: (userId, doc, fields, modifier) ->
#     # can only change your own documents
#     if doc.owner == userId then return true

    # Allow I Use It
    if (userId and
        fields.length == 1 and
        fields[0] == 'usedBy' and
        modifier.$set and
        modifier.$set.hasOwnProperty("usedBy.#{userId}"))
      return true

#     # Allowed to add comments
#     if (userId and
#         fields.length == 1 and
#         fields[0] == 'comments' and
#         modifier.$push and
#         modifier.$push.comments.commenter == userId)
#       return true

#   remove: (userId, doc) ->
#     # can only remove your own documents
#     doc.owner == userId

  fetch: ['owner']
  transform: null

# Wishes.deny
#   update: (userId, doc, fields, modifier) ->
#     # owner can't vote for himself
#     doc.owner == userId and 'votes' in fields

#   fetch: ['owner']

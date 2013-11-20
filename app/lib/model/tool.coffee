class @Tool extends Model
  transform = (data) -> new Tool(data)
  @_collection: new Meteor.Collection('tools', transform: transform)

  @find: (selector, options) ->
    super(_.extend({deletedAt: $exists: false}, selector), options)

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

  hasLogo: -> !!@data.logo
  logoUrl: (options) ->
    logo = @data.logo
    if not logo then return options.default
    Url.imageUrl(logo, options)

  setLogo: (url) ->
    Tool._collection.update({_id: @id()}, {$set: {logo: url}})
  removeLogo: ->
    Tool._collection.update({_id: @id()}, {$unset: {logo: 1}})

  # Can the current user edit the logo?
  canEditLogo: -> @data.creatorId == Meteor.userId()

  isUsedBy: (user) -> @_usedBy.has(user.id()) if user
  usedBy: (options) ->
    elems = @_usedBy.elements()
    if elems and elems.length
      User.findUsers({$or: elems.map((id)->{_id: id})}, options)

  setUsedBy: (user, used) -> @_usedBy.update(user.id(), used) if user

  isCurrentUserOwner: -> @data.creatorId == Meteor.userId()

  nameEditableByCurrentUser: -> @isCurrentUserOwner()

  rename: (name) ->
    if name == @name() then return
    Tool._collection.update({_id: @id()}, {$set: {name: name}})

  delete: ->
    Tool._collection.update({_id: @id()}, {$set: {deletedAt: new Date()}})

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

    # Allow deletion if you are the owner
    if (userId and
        userId == doc.data.creatorId and
        fields.length == 1 and
        fields[0] == 'deletedAt' and
        modifier.$set and
        modifier.$set.hasOwnProperty("deletedAt"))
      return true

    # Allow rename, if you are the owner
    if (userId and
        userId == doc.data.creatorId and
        fields.length == 1 and
        fields[0] == 'name' and
        modifier.$set and
        modifier.$set.hasOwnProperty("name"))
      return true

    # Allow change logo, if you are the owner
    if (userId and
        userId == doc.data.creatorId and
        fields.length == 1 and
        fields[0] == 'logo' and
        ((modifier.$set and modifier.$set.hasOwnProperty("logo")) or
        (modifier.$unset and modifier.$unset.hasOwnProperty("logo")))
        )
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

  fetch: ['creatorId']

# Wishes.deny
#   update: (userId, doc, fields, modifier) ->
#     # owner can't vote for himself
#     doc.owner == userId and 'votes' in fields

#   fetch: ['owner']

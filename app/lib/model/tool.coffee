class @Tool extends Model
  @_collection: new Meteor.Collection('tools', transform: (data) => @modelize(data))
  @modelize: (data) -> new Tool(data)

  constructor: (data) ->
    super(data)
    @_usedBy = new MinimongoidHashBooleanSet(Tool._collection, data, 'usedBy')


  name: -> @data.name
  id: -> @data._id
  createdAt: -> @data.createdAt
  updatedAt: -> @data.updatedAt
  deletedAt: -> @data.deletedAt
  creator: -> Contributor.findOne(@data.creatorId)

  logoUrl: (options) ->
    logo = @data.logo
    if not logo then return options.default
    Url.imageUrl(logo, options)

  isUsedBy: (contributor) -> @_usedBy.has(contributor.id())

  usedBy: ->
    Contributor.findOne(e) for e in @_usedBy.elements()

  setUsedBy: (contributor, used) -> @_usedBy.update(contributor.id(), used)

Tool._collection.allow
  insert: (userId, doc) ->
    # the user must be logged in, and the document must be owned by the user
    userId and doc.creatorId == userId

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

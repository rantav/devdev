class @User extends Model

  @_collection: Meteor.users

  transform = (doc) -> new User(doc)

  constructor: (data) ->
    super(data)
    @data ||= {}
    @data._id ||= 'unknown'
    @data.profile ||= {}
    @data.profile.color ||= '#fff'
    @data.profile.name ||= 'unknown'
    @_usedBy = new MinimongoidHashBooleanSet(User._collection, data, 'profile.usingTool')

  @findOneUser: (idOrName) ->
    Meteor.users.findOne(
      {$or: [{_id: idOrName}, {'profile.name': new RegExp('^' + idOrName + '$', 'i')}]},
      {transform: transform})

  @findUsers: (selector, options) ->
    Meteor.users.find(selector, _.extend({transform: transform}, options))

  # Current logged in user; undefined if the user is not logged in
  @current: ->
    new User(Meteor.user()) if Meteor.userId()

  id: -> @data._id
  name: -> @data.profile.name
  color: -> @data.profile.color
  route: -> Router.path('user', id: @id(), name: @name())
  isAdmin: -> @name() == "Ran Tavory" # Hah!
  anonymous: -> @id() == 'unknown'

  photoUrl: (height) ->
    if @data.services
      if @data.services.google
        picture = @data.services.google.picture
        if picture and height
          picture = "#{picture}?sz=#{height}"
      else if @data.services.github
        picture = @data.services.github.picture
        if picture and height
          picture = "#{picture}&s=#{height}"
    if not picture
      if height
        picture = Cdn.cdnify("/img/user-#{height}x#{height}.png")
      else
        picture = Cdn.cdnify('/img/user.png')
    picture

  setUsingTool: (tool, using) ->
    @_usedBy.update(tool.id(), using) if tool

  isUsingTool: (tool) ->
    @_usedBy.has(tool.id()) if tool

  usedTools: ->
    elems = @_usedBy.elements()
    if elems and elems.length
      Tool.find($or: elems.map((id)->{_id: id}))

  # save: ->
  #   Meteor.users.update(@data._id, @data)

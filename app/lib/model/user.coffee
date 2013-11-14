class @User extends Model
  Meteor.users._transform = (data) -> new User(data)
  @_collection: Meteor.users

  constructor: (data) ->
    super(data)
    @data ||= {}
    @data._id ||= 'unknown'
    @data.profile ||= {}
    @data.profile.color ||= '#fff'
    @data.profile.name ||= 'unknown'


  @findOne: (idOrName) ->
    super(idOrName) # TODO: || @findByName(idOrName)

  @findByName: (name) ->
    super.findOne({'profile.name': new RegExp('^' + idOrName + '$', 'i')})

  # Current logged in user; undefined if the user is not logged in
  @current: -> Meteor.user() # new User(Meteor.user()) if Meteor.userId()

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

  setUsingTechnology: (technology, using) ->
    if not @data.profile.usingTechnology then @data.profile.usingTechnology = {}
    @data.profile.usingTechnology[technology.id()] = using
    @save()

  isUsingTechnology: (technology) ->
    @data.profile.usingTechnology and @data.profile.usingTechnology[technology.id()]

  usedTechnologies: ->
    if not @data.profile.usingTechnology or not Session.get('devdevFullySynched')
      return []
    (Tool.findOne(techId) for techId, using of @data.profile.usingTechnology when using)

  # save: ->
  #   Meteor.users.update(@data._id, @data)

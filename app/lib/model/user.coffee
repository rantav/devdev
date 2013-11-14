root = exports ? this

root.Contributor = class Contributor

  @all: -> @find({})

  @find: (selector, options) ->
    (new Contributor(contribData) for contribData in Meteor.users.find(selector, options).fetch())

  @findOne: (idOrName) ->
    contribData = Contributors.findOne(idOrName)
    if not contribData
      contribData = Contributors.findOne({'profile.name': new RegExp('^' + idOrName + '$', 'i')})
    new Contributor(contribData)

  # Current logged in user; undefined if the user is not logged in
  @current: -> new Contributor(Meteor.user()) if Meteor.userId()

  constructor: (@data) ->
    if not @data then @data = {}
    if not @data._id then @data._id = 'unknown'
    if not @data.profile then @data.profile = {}
    if not @data.profile.color then @data.profile.color = '#fff'
    if not @data.profile.name then @data.profile.name = 'unknown'

  id: -> @data._id

  name: -> @data.profile.name

  color: -> @data.profile.color

  route: -> routes.contributor(@)

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
    (Technology.findOne(techId) for techId, using of @data.profile.usingTechnology when using)

  save: ->
    Meteor.users.update(@data._id, @data)

root.Contributors = Meteor.users

root = exports ? this

root.Technology = class Technology

  @all: -> @find({})

  # Finds all technologies, and filters out the ones that were deleted
  @find: (selector, options) ->
    if not selector
      selector = {}
    selector['deletedAt'] = {$exists: false}
    (new Technology(techData) for techData in Technologies.find(selector, options).fetch())

  @findOne: (idOrName) ->
    technologyData = Technologies.findOne idOrName
    if not technologyData
      technologyData = Technologies.findOne({name: new RegExp('^' + idOrName + '$', 'i')})
    if technologyData
      new Technology(technologyData)

  @add: (data) ->
    id = Technologies.insert data
    @findOne(id)


  @create: (name) ->
    now = new Date()
    tech =
      name: name
      contributorId: Meteor.userId()
      createdAt: now
      updatedAt: now
    Technology.add(tech)


  constructor: (@data) ->

  # creator: -> new Contributor(Meteor.users.findOne(@data.contributorId)) if @data

  # name: -> @data.name if @data

  # id: -> @data._id if @data

  # createdAt: -> @data.createdAt if @data

  # updatedAt: -> @data.updatedAt if @data

  # deletedAt: -> @data.deletedAt if @data

  # contributorId: -> @data.contributorId if @data

  # owner: -> Contributor.findOne(@data.contributorId) if @data

  route: -> routes.technology(@) if @data


  # Is the current logged in user the owner of this technology?
  # (owner is the one creating it in the first place)
  isCurrentUserOwner: -> Meteor.userId() == @contributorId()


  save: (updatedAt) ->
    updatedAt = updatedAt or new Date()
    @data.updatedAt = updatedAt
    Technologies.update(@id(), @data)

  saveNoTouch: ->
    Technologies.update(@id(), @data)

  delete: ->
    now = new Date()
    @data.deletedAt = now
    @save(now)

  nameEditableByCurrentUser: ->
    return Meteor.userId() == @data.contributorId

  setName: (newName) ->
    @data.name = newName
    @save()

  setUsedBy: (contributor, used) ->
    if not @data.usedBy then @data.usedBy = {}
    @data.usedBy[contributor.id()] = used
    @save(@updatedAt())

  # isUsedBy: (contributor) ->
  #   contributor and @data.usedBy and @data.usedBy[contributor.id()]

  # Returns the list of users that use this technology
  # usedBy: ->
  #   (Contributor.findOne(id) for id, used of @data.usedBy when used) if @data.usedBy


  # logoUrl: (options) ->
  #   logo = @data.logo
  #   if not logo then return options.default
  #   Url.imageUrl(logo, options)

root.Technologies = new Meteor.Collection "technologies"

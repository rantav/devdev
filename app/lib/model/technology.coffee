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

  @allAspectNames: ->
    _.map(@aspectDefinitions(), (e, i) -> i)

  @aspectDefinitions: ->
    'Tagline':
      type: 'markdown'
    , 'Websites':
      type: 'markdown'
    , 'Source Code':
      type: 'markdown'
    , 'Logo':
      type: 'image'
    , 'Typical Use Cases':
      type: 'markdown'
    , 'Sweet Spots':
      type: 'markdown'
    , 'Weaknesses':
      type: 'markdown'
    , 'Documentation':
      type: 'markdown'
    , 'Tutorials':
      type: 'markdown'
    , 'StackOverflow':
      type: 'markdown'
    , 'Mailing Lists':
      type: 'markdown'
    , 'IRC':
      type: 'markdown'
    , 'Development Status':
      type: 'markdown'
    , 'Used By':
      type: 'markdown'
    , 'Alternatives':
      type: 'markdown'
    , 'Complement Technologies':
      type: 'markdown'
    , 'Talks, Videos, Slides':
      type: 'markdown'
    ,'Cheatsheet / Examples':
      type: 'markdown'
    , 'Prerequisites':
      type: 'markdown'
    , 'Reviews':
      type: 'markdown'
    , 'Developers':
      type: 'markdown'
    , 'VersionEye':
      type: 'markdown'
    , 'Twitter':
      type: 'markdown'
    , 'Facebook':
      type: 'markdown'
    , 'Google+':
      type: 'markdown'
    , 'Hello World':
      type: 'markdown'
    , 'Comments':
      type: 'markdown'
    , 'More':
      type: 'markdown'

  @create: (name) ->
    aspectNames = @allAspectNames

    now = new Date()
    tech =
      name: name
      contributorId: Meteor.userId()
      aspects: (createAspect(a) for a in aspectNames)
      createdAt: now
      updatedAt: now
    Technology.add(tech)

  constructor: (@data) ->

  creator: -> new Contributor(Meteor.users.findOne(@data.contributorId)) if @data

  name: -> @data.name if @data

  id: -> @data._id if @data

  createdAt: -> @data.createdAt if @data

  updatedAt: -> @data.updatedAt if @data

  deletedAt: -> @data.deletedAt if @data

  contributorId: -> @data.contributorId if @data

  owner: -> Contributor.findOne(@data.contributorId) if @data

  route: -> routes.technology(@) if @data

  aspects: ->
    (new Aspect(aspectData, @) for aspectData in @data.aspects) if @data

  # Is the current logged in user the owner of this technology?
  # (owner is the one creating it in the first place)
  isCurrentUserOwner: -> Meteor.userId() == @contributorId()

  suggestAspectNames: ->
    ({value: name, tokens: _.union('?', Text.tokenize(name)), type: def.type} for name, def of Technology.aspectDefinitions())

  aspectNames: ->
    (aspectData.name for aspectData in @data.aspects)


  contributors: ->
    if @data
      contributorIds = [@data.contributorId].concat (contribution.contributorId for contribution in aspect.contributions for aspect in @data.aspects)...
      output = {}
      output[contributorIds[key]] = contributorIds[key] for key in [0...contributorIds.length]
      contributorIds = (value for key, value of output)
      (Contributor.findOne(contributorId) for contributorId in contributorIds)

  findAspectById: (aspectId) ->
    if @data and @data.aspects
      candidates = (aspect for aspect in @data.aspects when aspect.aspectId == aspectId)
      return new Aspect(candidates[0], @)
    else
      return new Aspect(null, @)

  findAspectByName: (name) ->
    if @data and @data.aspects
      candidates = (aspect for aspect in @data.aspects when aspect.name.toLowerCase() == name.toLowerCase())
      if (candidates[0])
        return new Aspect(candidates[0], @)

  findContributionById: (contributionId) ->
    for aspect in @aspects()
      contribution = aspect.findContributionById(contributionId)
      return contribution if contribution

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

  addAspectAndContribution: (aspectName, aspectTextValue) ->
    aspect = @findAspectByName(aspectName)
    if not aspect
      aspectData = createAspect(aspectName)
      @data.aspects.push(aspectData)
      aspect = new Aspect(aspectData, @)
    aspect.addContribution(aspectTextValue)


createAspect = (aspectName) ->
  name: aspectName
  contributions: []
  aspectId: Meteor.uuid()


root.Technologies = new Meteor.Collection "technologies"

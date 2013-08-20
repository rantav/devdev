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
    'tagline':
      type: 'markdown',
      display: 'Tagline'
    , 'websites':
      type: 'markdown',
      display: 'Websites'
    , 'source code':
      type: 'markdown',
      display: 'Source Code'
    , 'logo':
      type: 'image',
      display: 'Logo'
    , 'typical use cases':
      type: 'markdown',
      display: 'Typical Use Cases'
    , 'sweet spots':
      type: 'markdown',
      display: 'Sweet Spots'
    , 'weaknesses':
      type: 'markdown',
      display: 'Weaknesses'
    , 'documentation':
      type: 'markdown',
      display: 'Documentation'
    , 'tutorials':
      type: 'markdown',
      display: 'Tutorials'
    , 'stackoverflow':
      type: 'markdown',
      display: 'StackOverflow'
    , 'mailing lists':
      type: 'markdown',
      display: 'Mailing Lists'
    , 'irc':
      type: 'markdown',
      display: 'IRC'
    , 'development status':
      type: 'markdown',
      display: 'Development Status'
    , 'used by':
      type: 'markdown',
      display: 'Used By'
    , 'alternatives':
      type: 'markdown',
      display: 'Alternatives'
    , 'complement technologies':
      type: 'markdown',
      display: 'Complement Technologies'
    , 'talks, videos, slides':
      type: 'markdown',
      display: 'Talks, Videos, Slides'
    ,'cheatsheet / examples':
      type: 'markdown',
      display: 'Cheatsheet / Examples'
    , 'prerequisites':
      type: 'markdown',
      display: 'Prerequisites'
    , 'reviews':
      type: 'markdown',
      display: 'Reviews'
    , 'developers':
      type: 'markdown',
      display: 'Developers'
    , 'versioneye':
      type: 'markdown',
      display: 'VersionEye'
    , 'twitter':
      type: 'markdown',
      display: 'Twitter'
    , 'facebook':
      type: 'markdown',
      display: 'Facebook'
    , 'google+':
      type: 'markdown',
      display: 'Google+'
    , 'hello world':
      type: 'markdown',
      display: 'Hello World'
    , 'comments':
      type: 'markdown',
      display: 'Comments'
    , 'more':
      type: 'markdown',
      display: 'More'

  @typeForName: (name) ->
    def = Technology.aspectDefinitions()[name.toLowerCase()]
    if def then def.type else 'markdown'

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
    ({value: def.display, tokens: _.union('?', Text.tokenize(def.display)), type: def.type} for key, def of Technology.aspectDefinitions())

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

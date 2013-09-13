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
    aspectDefinitions

  @typeForName: (name) ->
    def = Technology.aspectDefinitions()[name.toLowerCase()]
    if def then def.type else 'markdown'

  @create: (name) ->
    now = new Date()
    tech =
      name: name
      contributorId: Meteor.userId()
      aspects: @createPinnedAspects()
      createdAt: now
      updatedAt: now
    Technology.add(tech)

  @createPinnedAspects: ->
    defs = @aspectDefinitions()
    (createAspect(defs[k].display, defs[k].type, k) for k in @pinnedAspectDefIds())

  # Gets all the pinned aspect definitions
  @pinnedAspectDefIds: ->
    (k for k, def of @aspectDefinitions() when def.pinned)

  @getAspectDef: (aspectDefId) ->
    @aspectDefinitions()[aspectDefId] || {type: 'markdown'}

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

  suggestVerticals: ->
    @suggestByDefId('vertical')

  suggestStacks: ->
    @suggestByDefId('stack')

  suggestByDefId: (defId) ->
    # This is a temporary solution until we get the tags component to work
    # well with elastic search...
    suggestions = []
    for technology in Technologies.find({deletedAt: {$exists: false}}).fetch()
      for aspect in technology.aspects
        if aspect.defId == defId
          for contribution in aspect.contributions
            suggestions = suggestions.concat(contribution.tags)
    suggestions = _.uniq(suggestions)

  # Gets all the tags for the stack
  getTagsForAspectDefId: (aspectDefId)->
    tags = []
    for aspect in @data.aspects
      if aspect.defId == aspectDefId
        aspectObj = new Aspect(aspect)
        for contribution in aspect.contributions
          if not contribution.deletedAt
            aspectContribution = new AspectContribution(contribution, aspectObj, @)
            newTags = aspectContribution.getTags()
            if newTags
              tags = _.union(tags, newTags)
    tags

  aspects: ->
    (new Aspect(aspectData, @) for aspectData in @data.aspects) if @data

  # Is the current logged in user the owner of this technology?
  # (owner is the one creating it in the first place)
  isCurrentUserOwner: -> Meteor.userId() == @contributorId()

  suggestAspectNames: ->
    {value: def.display, tokens: _.union('?', Text.tokenize(def.display)), type: def.type, defId: key} for key, def of Technology.aspectDefinitions()

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

  setUsedBy: (contributor, used) ->
    if not @data.usedBy then @data.usedBy = {}
    @data.usedBy[contributor.id()] = used
    @save(@updatedAt())

  isUsedBy: (contributor) ->
    contributor and @data.usedBy and @data.usedBy[contributor.id()]

  # Returns the list of users that use this technology
  usedBy: ->
    (Contributor.findOne(id) for id, used of @data.usedBy when used) if @data.usedBy

  addAspectAndContribution: (aspectName, aspectTextValue, aspectDefId, contributor) ->
    aspect = @findAspectByName(aspectName)
    if not aspect
      type = Technology.getAspectDef(aspectDefId).type
      aspectData = createAspect(aspectName, type, aspectDefId)
      @data.aspects.push(aspectData)
      aspect = new Aspect(aspectData, @)
    aspect.addContribution(aspectTextValue, contributor)

  numContributions: ->
    num = 0
    for aspect in @data.aspects
      for contribution in aspect.contributions
        if not contribution.deletedAt
          num++
    num

  logoUrl: (options) ->
    logo = @findLogoContribution()
    if not logo then return options.default
    logo.imageUrl(options)

  # Just picks up the first logo that it's able to find.
  findLogoContribution: ->
    for aspect in @data.aspects
      if aspect.name == 'Logo' and aspect.contributions.length
        for contribution in aspect.contributions
          if not contribution.deletedAt
            return new AspectContribution(contribution, new Aspect(aspect), @)

createAspect = (aspectName, type, aspectDefId) ->
  name: aspectName
  type: type
  contributions: []
  aspectId: Meteor.uuid()
  defId: aspectDefId


root.Technologies = new Meteor.Collection "technologies"

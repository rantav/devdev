class @Technology extends Minimongoid
  @_collection: new Meteor.Collection("technologies")
  @embeds_many: [{name: 'aspects'}]

  # Finds all technologies, and filters out the ones that were deleted
  @findUndeleted: (selector, options) ->
    if not selector
      selector = {}
    if typeof selector == 'object'
      selector['deletedAt'] = {$exists: false}
    @find(selector, options)

  # TODO: Fix find-by-name
  # @findOne: (idOrName) ->
  #   technologyData = Technologies.findOne idOrName
  #   if not technologyData
  #     technologyData = Technologies.findOne({name: new RegExp('^' + idOrName + '$', 'i')})
  #   if technologyData
  #     new Technology(technologyData)

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

  # creator: -> new Contributor(Meteor.users.findOne(@contributorId)) if @data
  # owner: -> Contributor.findOne(@data.contributorId) if @data

  route: -> Router.path('technology', {id: @id, name: @name})

  suggestVerticals: -> @suggestByDefId('vertical')

  suggestStacks: -> @suggestByDefId('stack')

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
    # TODO: Change from an array to a map by ID. Much more efficient and readable...
    candidates = (aspect for aspect in @aspects when aspect.aspectId == aspectId)
    candidates[0]

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
    # TODO: Prune all contributions referencing this technology
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
    (Contributor.find(id) for id, used of @data.usedBy when used) if @data.usedBy

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
    for aspect in @aspects
      if aspect.name == 'Logo'
        for contribution in aspect.aspectContributions
          return contribution unless contribution.deletedAt

createAspect = (aspectName, type, aspectDefId) ->
  name: aspectName
  type: type
  contributions: []
  aspectId: Meteor.uuid()
  defId: aspectDefId


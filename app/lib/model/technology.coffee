class @Technology extends Minimongoid
  @_collection: new Meteor.Collection("technologies")
  @embeds_many: [{name: 'aspects'}]
  @belongs_to: [{name: 'creator', identifier: 'contributorId', class_name: 'Contributor'}]

  # Finds all technologies, and filters out the ones that were deleted
  @findUndeleted: (selector, options) ->
    if not selector
      selector = {}
    if typeof selector == 'object'
      selector['deletedAt'] = {$exists: false}
    @where(selector, options)

  # TODO: Fix find-by-name
  # @findOne: (idOrName) ->
  #   technologyData = Technologies.findOne idOrName
  #   if not technologyData
  #     technologyData = Technologies.findOne({name: new RegExp('^' + idOrName + '$', 'i')})
  #   if technologyData
  #     new Technology(technologyData)

  # TODO: replace with create
  # https://github.com/Exygy/minimongoid/blob/master/lib/minimongoid.coffee#L262
  # @add: (data) ->
  #   id = Technologies.insert data
  #   @findOne(id)

  @allAspectNames: ->
    _.map(@aspectDefinitions(), (e, i) -> i)

  @aspectDefinitions: ->
    aspectDefinitions

  @typeForName: (name) ->
    def = Technology.aspectDefinitions()[name.toLowerCase()]
    if def then def.type else 'markdown'

  # TODO: replace with create
  # https://github.com/Exygy/minimongoid/blob/master/lib/minimongoid.coffee#L262
  # @create: (name) ->
  #   now = new Date()
  #   tech =
  #     name: name
  #     contributorId: Meteor.userId()
  #     aspects: @createPinnedAspects()
  #     createdAt: now
  #     updatedAt: now
  #   Technology.add(tech)

  @createPinnedAspects: ->
    defs = @aspectDefinitions()
    (createAspect(defs[k].display, defs[k].type, k) for k in @pinnedAspectDefIds())

  # Gets all the pinned aspect definitions
  @pinnedAspectDefIds: ->
    (k for k, def of @aspectDefinitions() when def.pinned)

  @getAspectDef: (aspectDefId) ->
    @aspectDefinitions()[aspectDefId] || {type: 'markdown'}

  owner: -> @creator()

  route: -> Router.path('technology', {id: @id, name: @name})

  suggestVerticals: -> @suggestByDefId('vertical')

  suggestStacks: -> @suggestByDefId('stack')

  suggestByDefId: (defId) ->
    # This is a temporary solution until we get the tags component to work
    # well with elastic search...
    suggestions = []
    for technology in Technology.find({deletedAt: {$exists: false}}).fetch()
      for aspect in technology.aspects
        if aspect.defId == defId
          for contribution in aspect.aspectContributions
            suggestions = suggestions.concat(contribution.tags)
    suggestions = _.uniq(suggestions)

  # Gets all the tags for the stack
  getTagsForAspectDefId: (aspectDefId)->
    tags = []
    for aspect in @aspects
      if aspect.defId == aspectDefId
        for contribution in aspect.aspectContributions
          if not contribution.deletedAt
            newTags = contribution.getTags()
            if newTags
              tags = _.union(tags, newTags)
    tags

  # Is the current logged in user the owner of this technology?
  # (owner is the one creating it in the first place)
  isCurrentUserOwner: -> Meteor.userId() == @contributorId

  suggestAspectNames: ->
    {value: def.display, tokens: _.union('?', Text.tokenize(def.display)), type: def.type, defId: key} for key, def of Technology.aspectDefinitions()

  aspectNames: ->
    (aspectData.name for aspectData in @data.aspects)

  contributors: ->
    contribs = [@creator()]
    for aspect in @aspects
      for aspectContribution in aspect.aspectContributions
        contribs.push(aspectContribution.contributor())
    _.uniq(contribs, false, (c) -> c.id)

  findAspectById: (aspectId) ->
    # TODO: Change from an array to a map by ID. Much more efficient and readable...
    candidates = (aspect for aspect in @aspects when aspect.aspectId == aspectId)
    candidates[0]

  findAspectByName: (name) ->
    for aspect in @aspects
      if aspect.name.toLowerCase() == name.toLowerCase()
        return aspect


  findContributionById: (contributionId) ->
    for aspect in @aspects
      contribution = aspect.findContributionById(contributionId)
      return contribution if contribution

  # TODO: refactor to adjust for minimongoid
  # save: (updatedAt) ->
  #   updatedAt = updatedAt or new Date()
  #   @updatedAt = updatedAt
  #   Technologies.update(@id, @)

  # TODO: refactor to adjust for minimongoid
  # saveNoTouch: ->
  #   Technologies.update(@id, @)

  # TODO: refactor to adjust for minimongoid
  # delete: ->
  #   now = new Date()
  #   @data.deletedAt = now
  #   # TODO: Prune all contributions referencing this technology
  #   @save(now)

  nameEditableByCurrentUser: -> Meteor.userId() == @contributorId

  setUsedBy: (contributor, used) ->
    updates = {}
    updates["usedBy.#{contributor.id}"] = used
    @save(updates)

  isUsedBy: (contributor) ->
    contributor and @usedBy and @usedBy[contributor.id]

  # Returns the list of users that use this technology
  usedByUsers: ->
    (Contributor.find(id) for id, used of @usedBy when used) if @usedBy

  addAspectAndContribution: (aspectName, aspectTextValue, aspectDefId, contributor) ->
    aspect = @findAspectByName(aspectName)
    if not aspect
      type = Technology.getAspectDef(aspectDefId).type
      aspectData = createAspect(aspectName, type, aspectDefId)
      @aspects.push(aspectData)
      aspect = new Aspect(aspectData, @)
    aspect.addContribution(aspectTextValue, contributor)

  numContributions: ->
    num = 0
    for aspect in @aspects
      for contribution in aspect.aspectContributions
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
  aspectContributions: []
  aspectId: Meteor.uuid()
  defId: aspectDefId


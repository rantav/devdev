class @Aspect extends Minimongoid
  @embedded_in: 'technology'
  @embeds_many: [{name: 'aspectContributions', class_name: 'AspectContribution'}]

  # constructor: (@data, @technologyRef) ->
  #   @dep = new Deps.Dependency()

  depend: ->
    @dep.depend()

  name: () => @data.name if @data

  setName: (n) =>
    @data.name = n
    @changed()

  id: => @data.aspectId

  defId: -> @data.defId if @data
  setDefId: (defId) -> @data.defId = defId

  setType: (t) ->
    @data.type = t
    @changed()
  typeIs: (t) -> @type == t

  helpText: ->
    if @defId and aspectDefinitions[@defId()] then aspectDefinitions[@defId()].help else undefined

  hasContributionsFromUser: (contributorId) ->
    return false if not @data.contributions
    for contribution in @data.contributions
      if contribution.contributorId == contributorId
        return true
    return false

  getContributionForUser: (contributorId) ->
    return null if not @data.contributions
    for contribution in @data.contributions
      if contribution.contributorId == contributorId
        return new AspectContribution(contribution, @)
    return null

  isSingleDataPerContributor: ->
    def = Technology.aspectDefinitions()[@defId()]
    return def and def.multiplicity == 'single-per-user'

  changed: -> @dep.changed()

  removeContribution: (aspectContribution) ->
    contributionId = aspectContribution.id()
    @data.contributions = (c for c in @data.contributions when not c.contributionId == contributionId)

  addContribution: (text, contributor) ->
    if not @data.contributions
      @data.contributions = []

    now = new Date()
    if @isSingleDataPerContributor() and @hasContributionsFromUser(contributor.id())
      aspectContribution = @getContributionForUser(contributor.id())
      aspectContribution.content = text
    else
      aspectContributionData =
        contributorId: Meteor.userId()
        content: text
        contributionId: Meteor.uuid()
        createdAt: now
        updatedAt: now
      @data.contributions.push(aspectContributionData)
      aspectContribution = new AspectContribution(aspectContributionData, @)
    if @type() == 'tags'
      aspectContribution.setTags(text)
    @save(now)
    aspectContribution

  findContributionById: (contributionId) ->
    # TODO: Turn this into a map, not an array of objects
    for contribution in @aspectContributions
      if contribution.contributionId == contributionId
        return contribution

  placeholderText: ->
    if @id() == 'new-aspect'
      if @type() == 'markdown'
        return "Say something about #{@name()}"
      else
        return '<- Type aspect name first'
    else
      return 'Add...'

  save: (modificationTime)->
    @technologyRef.save(modificationTime)

  storePath: ->
    if @type() == 'image' and @name() == 'Logo' then 'logos/'

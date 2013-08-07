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
    ['Tagline', 'Websites', 'Source Code', 'Typical Use Cases',
      'Sweet Spots', 'Weaknesses', 'Documentation', 'Tutorials', 'StackOverflow',
      'Mailing Lists', 'IRC', 'Development Status', 'Used By', 'Alternatives',
      'Complement Technologies', 'Talks, Videos, Slides', 'Cheatsheet / Examples', 'Prerequisites',
      'Reviews', 'Developers', 'VersionEye', 'Twitter', 'Facebook', 'Google+',
      'Hello World', 'Comments', 'More']

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
    _.difference(Technology.allAspectNames(), @aspectNames())

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

createAspect = (aspectName) ->
  name: aspectName
  contributions: []
  aspectId: Meteor.uuid()


root.Technologies = new Meteor.Collection "technologies"

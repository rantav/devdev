root = exports ? this

root.Technology = class Technology
  @all: ->
    (new Technology(techData) for techData in Technologies.find().fetch() when not techData.deletedAt)

  @find: (idOrName) ->
    technologyData = Technologies.findOne idOrName
    if not technologyData
      technologyData = Technologies.findOne({name: new RegExp('^' + idOrName + '$', 'i')})
    if technologyData
      new Technology(technologyData)

  constructor: (@data) ->

  creator: -> new Contributor(Meteor.users.findOne(@data.contributorId))

  name: -> @data.name

  id: -> @data._id

  createdAt: -> @data.createdAt

  updatedAt: -> @data.updatedAt

  deletedAt: -> @data.deletedAt

  contributorId: -> @data.contributorId

  route: -> routes.technology(@)

  aspects: ->
    (new Aspect(aspectData) for aspectData in @data.aspects)

  contributors: ->
    contributorIds = [@data.contributorId].concat (contribution.contributorId for contribution in aspect.contributions for aspect in @data.aspects)...
    output = {}
    output[contributorIds[key]] = contributorIds[key] for key in [0...contributorIds.length]
    contributorIds = (value for key, value of output)
    (Contributor.find(contributorId) for contributorId in contributorIds)

  findAspectById: (aspectId) ->
    candidates = (aspect for aspect in @data.aspects when aspect.aspectId == aspectId)
    candidates[0]

Technologies = root.Technologies = new Meteor.Collection "technologies"

# Finds an aspect by its name, in the given technology object
Technologies.findAspectByName = (technology, aspectName) ->
  candidates = (aspect for aspect in technology.aspects when aspect.name == aspectName)
  candidates[0]

# deleteme
Technologies.findAspectById = (technology, aspectId) ->
  candidates = (aspect for aspect in technology.aspects when aspect.aspectId == aspectId)
  candidates[0]

# deleteme
Technologies.findContributionInAspect = (aspect, contributionId) ->
  for contribution in aspect.contributions
    if contribution.contributionId == contributionId
      return contribution

Technologies.findContribution = (technology, contributionId) ->
  for aspect in technology.aspects
    contribution = Technologies.findContributionInAspect(aspect, contributionId)
    return contribution if contribution

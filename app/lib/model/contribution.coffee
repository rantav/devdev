root = exports ? this

root.Contribution = class Contribution

  constructor: (@data) ->
    @cache = {}

  technology: ->
    if @data
      cached = @cache.technology
      if not cached
        cached = Technology.findOne(@data.technologyId)
        @cache.technology = cached
      cached

  type: -> @data.type if @data

  aspect: ->
    if @data
      cached = @cache.aspect
      if not cached
        cached = @technology().findAspectById(@data.aspectId)
        @cache.aspect = cached
      cached

  content: ->
    @aspect().findContributionById(@data.contributionId) if @data

  contributorId: -> @data.contributorId

  typeIs: (typeStr) ->
    @type() == typeStr

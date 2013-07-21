root = exports ? this

root.Contribution = class Contribution

  constructor: (@data) ->
    @cache = {}

  technology: ->
    if @data
      cached = @cache.technology
      if not cached
        technologyData = Technologies.findOne(@data.technologyId)
        if technologyData
          cached = new Technology(technologyData)
          @cache.technology = cached
      cached

  type: -> @data.type if @data

  aspect: ->
    if @data
      cached = @cache.aspect
      if not cached
        aspectData = @technology().findAspectById(@data.aspectId)
        if aspectData
          cached = new Aspect(aspectData)
          @cache.aspect = cached
      cached

  content: ->
    new AspectContribution(@aspect().findContributionContentById(@data.contributionId)) if @data
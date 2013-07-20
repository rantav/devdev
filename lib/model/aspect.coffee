root = exports ? this

root.Aspect = class Aspect

  constructor: (@data) ->

  name: -> @data.name

  contributions: ->
    (new AspectContribution(aspectContributionData) for aspectContributionData in @data.contributions)

  isCurrentUserContributing: ->
    @data["contributing-" + Meteor.userId()]

  findContributionContentById: (contributionId) ->
    for contribution in @data.contributions
      if contribution.contributionId == contributionId
        return contribution

root = exports ? this

root.Aspect = class Aspect

  constructor: (@data, @technologyRef) ->

  name: -> @data.name

  id: -> @data.aspectId

  addContribution: (text) ->
    if not @data.contributions
      @data.contributions = []
    now = new Date()
    aspectContributionData =
      contributorId: Meteor.userId()
      markdown: text
      contributionId: Meteor.uuid()
      createdAt: now
      updatedAt: now

    @data.contributions.push(aspectContributionData)
    @technologyRef.save(now)
    new AspectContribution(aspectContributionData, @)

  contributions: ->
    (new AspectContribution(aspectContributionData, @) for aspectContributionData in @data.contributions)

  technology: -> @technologyRef

  isCurrentUserContributing: ->
    @data["contributing-" + Meteor.userId()]

  findContributionContentById: (contributionId) ->
    for contribution in @data.contributions
      if contribution.contributionId == contributionId
        return contribution

  toggleEditCurrentUser: ->
    @data['contributing-' + Meteor.userId()] = !@data['contributing-' + Meteor.userId()]
    @technologyRef.saveNoTouch()

  setEditCurrentUser: (edit) ->
    @data['contributing-' + Meteor.userId()] = edit
    @technologyRef.saveNoTouch()


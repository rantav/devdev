root = exports ? this

root.Aspect = class Aspect

  constructor: (@data, @technologyRef) ->
    @dep = new Deps.Dependency()

  depend: ->
    @dep.depend()

  name: (n) ->
    if n
      @data.name = n
      @changed()
    else @data.name

  id: -> @data.aspectId

  type: (t) ->
    if t
      @data.type = t
      @changed()
    else @data.type

  changed: -> @dep.changed()

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
    (new AspectContribution(aspectContributionData, @) for aspectContributionData in @data.contributions) if @data

  technology: -> @technologyRef

  findContributionById: (contributionId) ->
    if not @data
      return new AspectContribution(null, @)

    for contribution in @data.contributions
      if contribution.contributionId == contributionId
        return new AspectContribution(contribution, @)

  toggleEditCurrentUser: ->
    @data['contributing-' + Meteor.userId()] = !@data['contributing-' + Meteor.userId()]
    @technologyRef.saveNoTouch()

  setEditCurrentUser: (edit) ->
    @data['contributing-' + Meteor.userId()] = edit
    @technologyRef.saveNoTouch()

  placeholderText: ->
    if @id() == 'new-aspect'
      if @type == 'markdown'
        return "Say something about #{@name()}"
      else
        return '<- Type aspect name first'
    else
      return ''

  save: ->
    @technologyRef.save()

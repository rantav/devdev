root = exports ? this

root.Contributor = class Contributor

  @all: -> @find({})

  @find: (selector, options) ->
    (new Contributor(contribData) for contribData in Meteor.users.find(selector, options).fetch())

  @findOne: (idOrName) ->
    contribData = Contributors.findOne(idOrName)
    if not contribData
      contribData = Contributors.findOne({'profile.name': new RegExp('^' + idOrName + '$', 'i')})
    new Contributor(contribData)

  # Current logged in user; undefined if the user is not logged in
  @current: -> new Contributor(Meteor.user()) if Meteor.userId()

  constructor: (@data) ->
    if not @data then @data = {}
    if not @data._id then @data._id = 'unknown'
    if not @data.profile then @data.profile = {}
    if not @data.profile.color then @data.profile.color = '#fff'
    if not @data.profile.contributions then @data.profile.contributions = []
    if not @data.profile.contributionCount then @data.profile.contributionCount = 0
    if not @data.profile.name then @data.profile.name = 'unknown'

  contributionCount: ->
    @data.profile.contributionCount || 0

  id: -> @data._id

  name: -> @data.profile.name

  color: -> @data.profile.color

  route: -> routes.contributor(@)

  photoHtml: (imgClass) ->
    if @data.services
      if @data.services.google
        picture = @data.services.google.picture
      else if @data.services.github
        picture = @data.services.github.picture

    if not imgClass then imgClass = 'img-polaroid'
    if not picture then picture = '/img/user.png'
    "<img src='#{picture}' class='#{imgClass}'/>"

  # Gets all undeleted contributions from the contributor
  contributions: ->
    (new Contribution(contribData) for contribData in @data.profile.contributions when not contribData.deletedAt)

  addTechnologyContribution: (technology) ->
    if not @data.profile.contributions
      @data.profile.contributions = []
    if not @data.profile.contributionCount
      @data.profile.contributionCount = 0
    @data.profile.contributions.push
      technologyId: technology.id()
      type: 'technology'
      createdAt: technology.createdAt()
      updatedAt: technology.updatedAt()
    @data.profile.contributionCount++;
    @save(technology.updatedAt())

  addAspectContribution: (aspectContribution) ->
    if not @data.profile.contributions
      @data.profile.contributions = []
    if not @data.profile.contributionCount
      @data.profile.contributionCount = 0
    @data.profile.contributions.push
      technologyId: aspectContribution.aspect().technology().id()
      aspectId: aspectContribution.aspect().id()
      contributionId: aspectContribution.id()
      type: 'aspectContribution'
      createdAt: aspectContribution.createdAt()
      updatedAt: aspectContribution.updatedAt()
    @data.profile.contributionCount++;
    @save(aspectContribution.updatedAt())

  save: ->
    Meteor.users.update(@data._id, @data)

  findUserAspectContribution: (aspectContribution) ->
    candidates = (contribution for contribution in @data.profile.contributions when contribution.contributionId == aspectContribution.id())
    candidates[0]

  findUserTechnologyContributions: (technology) ->
    (contribution for contribution in @data.profile.contributions when contribution.technologyId == technology.id())

  deleteAspectContribution: (aspectContribution) ->
    userContributionData = @findUserAspectContribution(aspectContribution)
    userContributionData.deletedAt = new Date()
    @data.profile.contributionCount--;
    @save()

  # TODO: Delete all other aspect contributions (from all other users as well)
  deleteTechnologyContribution: (technology) ->
    userContributionData = @findUserTechnologyContributions(technology)
    userContributionData.deletedAt = new Date()
    @data.profile.contributionCount--;
    @save()

root.Contributors = Meteor.users

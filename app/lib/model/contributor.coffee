root = exports ? this

root.Contributor = class Contributor

  @all: ->
    (new Contributor(contribData) for contribData in Meteor.users.find().fetch())

  @findOne: (idOrName) ->
    contribData = Contributors.findOne(idOrName)
    if not contribData
      contribData = Contributors.findOne({'profile.name': new RegExp('^' + idOrName + '$', 'i')})
    if contribData
      new Contributor(contribData)
    else
      new Contributor({_id: 'unknown', profile: {name: 'unknown', 'color': '#fff'}})

  # Current logged in user; undefined if the user is not logged in
  @current: -> new Contributor(Meteor.user()) if Meteor.userId()

  constructor: (@data) ->

  countContributions: ->
    (contribData for contribData in @data.profile.contributions when not contribData.deletedAt).length

  id: -> @data._id if @data

  name: -> @data.profile.name if @data

  color: -> @data.profile.color if @data

  route: -> routes.contributor(@) if @data

  photoHtml: ->
    if @data and @data.services
      if @data.services.google
        picture = @data.services.google.picture
      else if @data.services.github
        picture = @data.services.github.picture

    if not picture
      picture = '/img/user.png'
    "<img src='#{picture}' class='img-polaroid'/>"

  # Gets all undeleted contributions from the contributor
  contributions: ->
    (new Contribution(contribData) for contribData in @data.profile.contributions when not contribData.deletedAt) if @data

  addTechnologyContribution: (technology) ->
    if not @data.profile.contributions
      @data.profile.contributions = []
    @data.profile.contributions.push
      technologyId: technology.id()
      type: 'technology'
      createdAt: technology.createdAt()
      updatedAt: technology.updatedAt()
    @save(technology.updatedAt())

  addAspectContribution: (aspectContribution) ->
    if not @data.profile.contributions
      @data.profile.contributions = []
    @data.profile.contributions.push
      technologyId: aspectContribution.aspect().technology().id()
      aspectId: aspectContribution.aspect().id()
      contributionId: aspectContribution.id()
      type: 'aspectContribution'
      createdAt: aspectContribution.createdAt()
      updatedAt: aspectContribution.updatedAt()
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
    @save()

  # TODO: Delete all other aspect contributions (from all other users as well)
  deleteTechnologyContribution: (technology) ->
    userContributionData = @findUserTechnologyContributions(technology)
    userContributionData.deletedAt = new Date()
    @save()

root.Contributors = Meteor.users

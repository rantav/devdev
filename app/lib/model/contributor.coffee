class @Contributor extends Minimongoid
  @_collection: Meteor.users

  @embeds_many: [{name: 'contributions'}]

  @defaults:
    id: 'unknown'

  @current: -> Contributor.init(Meteor.user()) if Meteor.userId()

  contributionCount: -> @profile.contributionCount || 0

  name: -> @profile.name
  color: -> @profile.color
  route: -> Router.path('contributor', id: @id, name: @name())

  isAdmin: -> @name() == "Ran Tavory" # Hah!

  anonymous: -> @id == 'unknown'

  photoUrl: (height) ->
    if @services
      if @services.google
        picture = @services.google.picture
        if picture and height
          picture = "#{picture}?sz=#{height}"
      else if @services.github
        picture = @services.github.picture
        if picture and height
          picture = "#{picture}&s=#{height}"
      else if @services.facebook
        picture = "http://graph.facebook.com/#{@services.facebook.id}/picture/"
        if height
          picture = "#{picture}?height=#{height/2}&width=#{height/2}"
      else if @services.twitter
        picture = @services.twitter.profile_image_url
    if not picture
      if height
        picture = Cdn.cdnify("/img/user-#{height}x#{height}.png")
      else
        picture = Cdn.cdnify('/img/user.png')
    picture


  # Gets all undeleted contributions from the contributor
  # TODO: Make this mongoid
  # contributions: ->
  #   (new Contribution(contribData) for contribData in @profile.contributions when not contribData.deletedAt)

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

  setUsingTechnology: (technology, using) ->
    if not @data.profile.usingTechnology then @data.profile.usingTechnology = {}
    @data.profile.usingTechnology[technology.id()] = using
    @save()

  isUsingTechnology: (technology) ->
    @data.profile.usingTechnology and @data.profile.usingTechnology[technology.id()]

  usedTechnologies: ->
    if not @profile.usingTechnology or not Session.get('devdevFullySynched')
      return []
    (Technology.find(techId) for techId, using of @profile.usingTechnology when using)

  save: ->
    Meteor.users.update(@data._id, @data)

  findUserAspectContribution: (aspectContribution) ->
    candidates = (contribution for contribution in @data.profile.contributions when contribution.contributionId == aspectContribution.id())
    candidates[0]

  findUserTechnologyContributions: (technology) ->
    (contribution for contribution in @data.profile.contributions when contribution.technologyId == technology.id())

  deleteAspectContribution: (aspectContribution) ->
    # TODO: Test deletion
    userContribution = @findUserAspectContribution(aspectContribution)
    userContribution.destroy()
    @data.profile.contributionCount--;
    @save()

  # TODO: Delete all other aspect contributions (from all other users as well)
  deleteTechnologyContribution: (technology) ->
    userContributionData = @findUserTechnologyContributions(technology)
    userContributionData.deletedAt = new Date()
    @data.profile.contributionCount--;
    @save()


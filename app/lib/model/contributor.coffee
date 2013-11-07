class @Contributor extends Minimongoid
  @_collection: Meteor.users

  @embeds_many: [{name: 'contributions'}]

  @defaults:
    id: 'unknown'

  @current: -> Contributor.init(Meteor.user()) if Meteor.userId()

  contributionCount: -> @contributions.length

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
    if not @contributions
      @contributions = []
    @contributions.push
      technologyId: technology.id()
      type: 'technology'
      createdAt: technology.createdAt()
      updatedAt: technology.updatedAt()

  addAspectContribution: (aspectContribution) ->
    if not @contributions
      @contributions = []
    @contributions.push
      technologyId: aspectContribution.aspect.technology.id
      aspectId: aspectContribution.aspect.id
      contributionId: aspectContribution.id
      type: 'aspectContribution'
      createdAt: aspectContribution.createdAt
      updatedAt: aspectContribution.updatedAt

  setUsingTechnology: (technology, using) ->
    updates = {}
    updates["profile.usingTechnology.#{technology.id}"] = using
    @save(updates)

  isUsingTechnology: (technology) ->
    @profile.usingTechnology and @profile.usingTechnology[technology.id]

  usedTechnologies: ->
    if not @profile.usingTechnology or not Session.get('devdevFullySynched')
      return []
    (Technology.find(techId) for techId, using of @profile.usingTechnology when using)

  findUserAspectContribution: (aspectContribution) ->
    candidates = (contribution for contribution in @profile.contributions when contribution.contributionId == aspectContribution.id())
    candidates[0]

  findUserTechnologyContributions: (technology) ->
    (contribution for contribution in @profile.contributions when contribution.technologyId == technology.id())

  deleteAspectContribution: (aspectContribution) ->
    userContribution = @findUserAspectContribution(aspectContribution)
    userContribution.destroy()
    # @save()

  # TODO: Delete all other aspect contributions (from all other users as well)
  deleteTechnologyContribution: (technology) ->
    userContributionData = @findUserTechnologyContributions(technology)
    userContributionData.deletedAt = new Date()
    # @save()


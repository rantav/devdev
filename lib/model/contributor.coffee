root = exports ? this

root.Contributor = class Contributor

  @all: ->
    (new Contributor(contribData) for contribData in Meteor.users.find().fetch())

  @find: (idOrName) ->
    contribData = Meteor.users.findOne(idOrName)
    if not contribData
      contribData = Contributors.findOne({name: new RegExp('^' + idOrName + '$', 'i')})
    if contribData
      new Contributor(contribData)
    else
      new Contributor({_id: 'unknown', profile: {name: 'unknown', 'color': '#fff'}})

  constructor: (@data) ->

  countContributions: ->
    (contribData for contribData in @data.profile.contributions when not contribData.deletedAt).length

  id: -> @data._id if @data

  name: -> @data.profile.name if @data

  color: -> @data.profile.color if @data

  route: -> routes.contributor(@) if @data

  photoHtml: ->
    if @data and @data.services and @data.services.google
      picture = @data.services.google.picture
    if not picture
      picture = '/img/user.png'
    "<img src='#{picture}' class='img-polaroid'/>"

  # Gets all undeleted contributions from the contributor
  contributions: ->
    (new Contribution(contribData) for contribData in @data.profile.contributions when not contribData.deletedAt) if @data


root.Contributor = Contributor

Contributors = root.Contributors = Meteor.users

Contributors.getNameById = (contributorId) ->
  contributor = Contributors.findOne(contributorId)
  if contributor
    contributor.profile.name

# deleteme
Contributors.getColorById = (contributorId) ->
  contributor = Contributors.findOne(contributorId)
  if contributor
    contributor.profile.color

Contributors.getPhotoHtmlById = (contributorId) ->
  contributor = Contributors.findOne contributorId
  Contributors.getPhotoHtml contributor

# delete
Contributors.getPhotoHtml = (contributor) ->
  if contributor and contributor.services and contributor.services.google
    picture = contributor.services.google.picture
    if not picture
      picture = '/img/user.png'
    "<img src='#{picture}' class='img-polaroid'/>"

Contributors.findAspectContribution = (contributor, contributionId) ->
  candidates = (contribution for contribution in contributor.profile.contributions when contribution.contributionId == contributionId)
  candidates[0]

Contributors.findTechnologyContributions = (contributor, technologyId) ->
  (contribution for contribution in contributor.profile.contributions when contribution.technologyId == technologyId)

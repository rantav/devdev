root = exports ? this

Contributors = root.Contributors = Meteor.users

Contributors.getNameById = (contributorId) ->
  contributor = Contributors.findOne(contributorId)
  if contributor
    contributor.profile.name

Contributors.getColorById = (contributorId) ->
  contributor = Contributors.findOne(contributorId)
  if contributor
    contributor.profile.color

Contributors.getPhotoHtmlById = (contributorId) ->
  contributor = Contributors.findOne contributorId
  Contributors.getPhotoHtml contributor

Contributors.getPhotoHtml = (contributor) ->
  if contributor and contributor.services and contributor.services.google
    picture = contributor.services.google.picture
    if picture
      html = "<img src='#{picture}' class='img-polaroid'/>"
  if not picture
    html = '<i class="icon-user icon-3x img-polaroid">&nbsp</i>'
  html


# Gets all undeleted contributions from the contributor
Contributors.getContributions = (contributor) ->
  (contribution for contribution in contributor.profile.contributions when not contribution.deletedAt)

Contributors.findAspectContribution = (contributor, contributionId) ->
  candidates = (contribution for contribution in contributor.profile.contributions when contribution.contributionId == contributionId)
  candidates[0]

Contributors.findTechnologyContributions = (contributor, technologyId) ->
  (contribution for contribution in contributor.profile.contributions when contribution.technologyId == technologyId)

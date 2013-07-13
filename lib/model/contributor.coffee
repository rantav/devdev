root = exports ? this

Contributors = root.Contributors = Meteor.users

# Gets all undeleted contributions from the contributor
Contributors.getContributions = (contributor) ->
  (contribution for contribution in contributor.profile.contributions when not contribution.deletedAt)

Contributors.findAspectContribution = (contributor, contributionId) ->
  candidates = (contribution for contribution in contributor.profile.contributions when contribution.contributionId == contributionId)
  candidates[0]

Contributors.findTechnologyContributions = (contributor, technologyId) ->
  (contribution for contribution in contributor.profile.contributions when contribution.technologyId == technologyId)

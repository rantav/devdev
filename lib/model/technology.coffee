root = exports ? this

Technologies = root.Technologies = new Meteor.Collection "technogies"

# Finds an aspect by its name, in the given technology object
Technologies.findAspectByName = (technology, aspectName) ->
  candidates = (aspect for aspect in technology.aspects when aspect.name == aspectName)
  candidates[0]

Technologies.findAspectById = (technology, aspectId) ->
  candidates = (aspect for aspect in technology.aspects when aspect.aspectId == aspectId)
  candidates[0]

Technologies.findContributionInAspect = (aspect, contributionId) ->
  for contribution in aspect.contributions
    if contribution.contributionId == contributionId
      return contribution

Technologies.findContribution = (technology, contributionId) ->
  for aspect in technology.aspects
    contribution = Technologies.findContributionInAspect(aspect, contributionId)
    return contribution if contribution

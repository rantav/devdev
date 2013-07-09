root = exports ? this

Technologies = root.Technologies = new Meteor.Collection "technogies"

# Finds an aspect by its name, in the given technology object
Technologies.findAspect = (technology, aspectName) ->
  candidates = (aspect for aspect in technology.aspects when aspect.name == aspectName)
  candidates[0]


Technologies.findContribution = (technology, contributionId) ->
  for aspect in technology.aspects
    for contribution in aspect.contributions
      if contribution.contributionId == contributionId
        return contribution

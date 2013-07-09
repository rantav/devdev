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

# TODO: Move this out of here
if Meteor.isServer
  ran = Meteor.users.findOne {'profile.name': 'Ran Tavory'}
  yael = Meteor.users.findOne {'profile.name': 'Yael Tavory'}
  if ran and not ran.profile.color
    ran.profile.color = '#a979d9'
    # unused color: rgb(255, 177, 177)
    Meteor.users.update ran._id, ran

root = exports ? this

root.AspectContribution = class AspectContribution

  constructor: (@data) ->

  createdAt: -> @data.createdAt

  updatedAt: -> @data.updatedAt

  deletedAt: -> @data.deletedAt

  markdown: -> @data.markdown

  contributor: -> Contributor.find(@data.contributorId)

  contributionId: -> @data.contributionId

  # Is the current logged in use the owner of this contribution?
  isCurrentUserOwner: -> Meteor.userId() == @data.contributorId

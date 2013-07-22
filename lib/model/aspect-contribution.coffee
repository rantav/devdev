root = exports ? this

root.AspectContribution = class AspectContribution

  constructor: (@data, @aspectRef) ->

  createdAt: -> @data.createdAt

  updatedAt: -> @data.updatedAt

  deletedAt: -> @data.deletedAt

  markdown: -> @data.markdown

  contributor: -> Contributor.find(@data.contributorId)

  contributionId: -> @data.contributionId

  # Is the current logged in user the owner of this contribution?
  isCurrentUserOwner: -> Meteor.userId() == @data.contributorId

  aspect: -> @aspectRef

  id: -> @data.contributionId

  delete: ->
    @data.deletedAt = new Date()
    @save()

  save: ->
    @aspectRef.save()
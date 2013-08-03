root = exports ? this

root.AspectContribution = class AspectContribution

  constructor: (@data, @aspectRef) ->

  createdAt: -> @data.createdAt if @data

  updatedAt: -> @data.updatedAt if @data

  deletedAt: -> @data.deletedAt if @data

  markdown: -> if @data then @data.markdown else ""

  markdownWithSmartLinks: ->
    Text.markdownWithSmartLinks(@markdown())

  contributor: -> Contributor.findOne(@data.contributorId)

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
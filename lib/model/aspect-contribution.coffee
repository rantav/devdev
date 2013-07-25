root = exports ? this

root.AspectContribution = class AspectContribution

  constructor: (@data, @aspectRef) ->

  createdAt: -> @data.createdAt

  updatedAt: -> @data.updatedAt

  deletedAt: -> @data.deletedAt

  markdown: -> @data.markdown

  # Same as markdown, but looks for "smart links and makes them actual links".
  # for example /technology/javascript becomes [/technology/javascript](/technology/javascript)
  # which is easily translated by marked to html links
  markdownWithSmartLinks: ->
    Text.markdownWithSmartLinks(@markdown())

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
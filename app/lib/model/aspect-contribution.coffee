root = exports ? this

root.AspectContribution = class AspectContribution

  constructor: (@data, @aspectRef) ->

  createdAt: -> @data.createdAt if @data

  updatedAt: -> @data.updatedAt if @data

  deletedAt: -> @data.deletedAt if @data

  content: -> if @data then @data.content else ""

  setContent: (content) ->
    if content
      @data.content = content
    else
      @remove()

  markdownProcessed: ->
    text = @content()
    text = Text.escapeMarkdown(text)
    text = Text.markdownWithSmartLinks(text)
    text

  contributor: -> Contributor.findOne(@data.contributorId)

  contributorId: -> @data.contributorId

  contributionId: -> @data.contributionId

  # Is the current logged in user the owner of this contribution?
  isCurrentUserOwner: -> Meteor.userId() == @data.contributorId

  aspect: -> @aspectRef
  technology: -> @aspect().technology()

  defId: -> @aspect().defId()

  id: -> @data.contributionId

  remove: ->
    @aspect().removeContribution(@)

  delete: ->
    @data.deletedAt = new Date()
    @save()

  save: ->
    @aspectRef.save()

  # Assumes the data stored is tags and gets an array of them
  getTags: ->
    return @data.tags

  setTags: (text) ->
    @data.tags = (tag.trim() for tag in text.split(',') when tag.trim())
    @data.content = text


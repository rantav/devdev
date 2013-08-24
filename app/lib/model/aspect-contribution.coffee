root = exports ? this

root.AspectContribution = class AspectContribution

  constructor: (@data, @aspectRef) ->

  createdAt: -> @data.createdAt if @data

  updatedAt: -> @data.updatedAt if @data

  deletedAt: -> @data.deletedAt if @data

  content: -> @markdown()

  #TODO: Rename markdown to content. b/c not everything is markdown today...
  markdown: -> if @data then @data.markdown else ""

  markdownProcessed: ->
    text = @markdown()
    text = Text.escapeMarkdown(text)
    text = Text.markdownWithSmartLinks(text)
    text

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

  imageUrl: (w, h) ->
    url = @content()
    if not url.indexOf('http') == 0 then return null
    url = "#{url}/convert?w=#{w}&h=#{h}&fit=clip&cache=true"
    cdned = Cdn.cdnify(url)

root = exports ? this

root.AspectContribution = class AspectContribution

  constructor: (@data, @aspectRef) ->

  createdAt: -> @data.createdAt if @data

  updatedAt: -> @data.updatedAt if @data

  deletedAt: -> @data.deletedAt if @data

  content: -> @markdown()

  setContent: (content) ->
    if content
      @data.markdown = content
    else
      @remove()

  #TODO: Rename markdown to content. b/c not everything is markdown today...
  markdown: -> if @data then @data.markdown else ""

  markdownProcessed: ->
    text = @markdown()
    text = Text.escapeMarkdown(text)
    text = Text.markdownWithSmartLinks(text)
    text

  contributor: -> Contributor.findOne(@data.contributorId)

  contributorId: -> @data.contributorId

  contributionId: -> @data.contributionId

  # Is the current logged in user the owner of this contribution?
  isCurrentUserOwner: -> Meteor.userId() == @data.contributorId

  aspect: -> @aspectRef

  id: -> @data.contributionId

  remove: ->
    @aspect().removeContribution(@)

  delete: ->
    @data.deletedAt = new Date()
    @save()

  save: ->
    @aspectRef.save()

  # provide options as {w: 5, h: 6}
  imageUrl: (options) ->
    url = @content()
    if not url.indexOf('http') == 0 then return null
    w = if options and options.w then "&w=#{options.w}" else ''
    h = if options and options.h then "&h=#{options.h}" else ''
    url = "#{url}/convert?#{w}#{h}&fit=clip&cache=true"
    cdned = Cdn.cdnify(url)

class @AspectContribution extends Minimongoid
  @embedded_in: 'aspect'

  markdownProcessed: ->
    text = @content
    text = Text.escapeMarkdown(text)
    text = Text.markdownWithSmartLinks(text)
    text

  contributor: -> Contributor.findOne(@data.contributorId)

  contributorId: -> @data.contributorId

  contributionId: -> @data.contributionId

  # Is the current logged in user the owner of this contribution?
  isCurrentUserOwner: -> Meteor.userId() == @data.contributorId

  typeIs: (t) -> @aspect.typeIs(t)
  
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

  # provide options as {w: 5, h: 6}
  imageUrl: (options) ->
    url = @content
    if not url.indexOf('http') == 0 then return null
    w = if options and options.w then "&w=#{options.w}" else ''
    h = if options and options.h then "&h=#{options.h}" else ''
    url = "#{url}/convert?#{w}#{h}&fit=clip&cache=true"
    cdned = Cdn.cdnify(url)

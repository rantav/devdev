class @AspectContribution extends Minimongoid
  @embedded_in: 'aspect'
  @belongs_to: [{name: 'contributor', identifier: 'contributorId'}]

  markdownProcessed: ->
    text = @content
    text = Text.escapeMarkdown(text)
    text = Text.markdownWithSmartLinks(text)
    text

  # Is the current logged in user the owner of this contribution?
  isCurrentUserOwner: -> Meteor.userId() == @contributorId

  typeIs: (t) ->
    @aspect.typeIs(t)

  defId: -> @aspect().defId

  id: -> @contributionId

  # TODO minimongoid
  remove: ->
    @aspect().removeContribution(@)

  # TODO minimongoid
  delete: ->
    @deletedAt = new Date()
    @save()

  # TODO minimongoid
  save: ->
    @aspectRef.save()

  # Assumes the data stored is tags and gets an array of them
  getTags: ->
    return @tags

  setTags: (text) ->
    @tags = (tag.trim() for tag in text.split(',') when tag.trim())
    @content = text

  # provide options as {w: 5, h: 6}
  imageUrl: (options) ->
    url = @content
    if not url.indexOf('http') == 0 then return null
    w = if options and options.w then "&w=#{options.w}" else ''
    h = if options and options.h then "&h=#{options.h}" else ''
    url = "#{url}/convert?#{w}#{h}&fit=clip&cache=true"
    cdned = Cdn.cdnify(url)

  data: ->
    _.object(
      _.without(
        _.map(
          _.pairs(@),
          (kv) ->
            if kv[0] in ['aspect', 'contributor'] then return null
            return kv
        )
        ,null
      )
    )

Template.tagsAspectEditor.rendered = ->
  $el = $(@find('.tagsinput'))
  defId = $el.data('defid')
  def = Technology.aspectDefinitions()[defId]
  datasource = def.datasource
  $el.tagsinput({
    typeahead: {
      local: @data.technology()[datasource](),
      freeInput: true
    }
  })

Template.tagsAspectEditor.events
  'focus .tags-aspect input': (event) ->
    $target = $(event.target)
    $target.parents('.edit-section').find('.controls').show(200)
  'blur .tags-aspect input': (event) ->
    $target = $(event.target)
    $target.parents('.edit-section').find('.controls').hide(200)

  'submit .tags-aspect form.contribute-form': (event) ->
    text = $(event.target).find('input.tt-query').val()
    text = (t.trim() for t in text.split(','))
    tags = $(event.target).find(".tagsinput").tagsinput('items')
    tags = _.union(tags, text)
    if @id() == 'new-aspect'
      handleNewAspect(this, tags)
    else
      aspect = if this instanceof AspectContribution then this.aspect() else this
      handleAspectContribution(aspect, tags)
    # return false to prevent browser form submission
    false


handleAspectContribution = (aspect, tags) ->
  analytics.track('Submit aspect contribution')
  text = tags.join(',')
  if text
    NProgress.start()
    Meteor.call 'contributeToAspect', aspect.technology().id(), aspect.id(), text, (err, ret) ->
      if err
        alertify.error err
      else
        NProgress.done()

handleNewAspect = (aspect, tags) =>
  $name = $('#new-aspect-name')
  name = $name.val()
  if not name
    $name.parents('.control-group').addClass('error')
    $name.focus()
    return
  text = tags.join(',')
  if not text then return
  def = aspect.defId()
  analytics.track('add new aspect', {name: name})
  NProgress.start()
  Meteor.call 'contributeNewAspect', aspect.technology().id(), name, text, def, (err, ret) ->
    if err
      alertify.error err
      NProgress.done()
    else
      $name.val('')
      aspect.setType(undefined)
      aspect.setName(undefined)
      aspect.setDefId(undefined)
      NProgress.done()



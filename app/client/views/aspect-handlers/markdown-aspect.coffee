Template.markdownAspectEditor.rendered = ->
  $('textarea.contribute-text').autogrow()

Template.markdownAspectEditor.events
  'click .markdown-aspect.cancel-contribution': (event)->
    $target = $(event.target)
    $target.parent().hide(200)
    $target.parents('.edit-section').find('textarea.contribute-text').val('')
    $target.parents('.edit-section').find('.contribute-preview').html('')
    $target.parents('.edit-section').find('.control-group').removeClass('error')

  'submit .markdown-aspect form.contribute-form': (event) ->
    if @id() == 'new-aspect'
      handleNewAspect(this, event)
    else
      handleAspectContribution(this, event)
    # return false to prevent browser form submission
    false

  'keyup .markdown-aspect textarea.contribute-text': (event) ->
    $target = $(event.target)
    text = $target.val()
    text = Text.markdownWithSmartLinks(text)
    text = Text.escapeMarkdown(text)
    html = marked(text)
    $target.parents('.edit-section').find('.contribute-preview').html(html)
    if text
      $target.parents('.control-group').removeClass('error')
    else
      $target.parents('.control-group').addClass('error')


  'blur .markdown-aspect textarea.contribute-text': (event) ->
    $relatedTarget = $(event.relatedTarget)
    if $relatedTarget.data('referred-id') == event.target.id
      # Don't hide the controls if they have the focus
      return
    $target = $(event.target)
    $target.parents('.edit-section').find('.controls').hide(200)
    $target.parents('.edit-section').find('.control-group').removeClass('error')

  'blur .markdown-aspect .controls button': (event) ->
    $target = $(event.target)
    if event.relatedTarget
      $relatedTarget = $(event.relatedTarget)
      if $relatedTarget.data('referred-id') == $target.data('referred-id') or event.relatedTarget.id == $target.data('referred-id')
        # Don't hide the controls if they have the focus
        return
    $target.parent().hide(200)
    $target.parents('.edit-section').find('.control-group').removeClass('error')

  'focus .markdown-aspect textarea.contribute-text': (event) ->
    $target = $(event.target)
    $target.parents('.edit-section').find('.controls').show(200)

handleAspectContribution = (aspect, event) ->
  analytics.track('Submit aspect contribution')
  text = $('textarea.contribute-text', event.target).val()
  if text
    NProgress.start()
    Meteor.call 'contributeToAspect', aspect.technology().id(), aspect.id(), text, (err, ret) ->
      if err
        alertify.error err
      else
        $target = $(event.target)
        $target.find('textarea.contribute-text').val('')
        NProgress.done()

handleNewAspect = (aspect, event) =>
  $name = $('#new-aspect-name')
  name = $name.val()
  if not name
    $name.parents('.control-group').addClass('error')
    $name.focus()
    return
  $value = $('#new-aspect-value')
  value = $value.val()
  if not value
    $value.parents('.control-group').addClass('error')
    $value.focus()
    return

  def = aspect.defId()
  analytics.track('add new aspect', {name: name})
  NProgress.start()
  Meteor.call 'contributeNewAspect', aspect.technology().id(), name, value, def, (err, ret) ->
    if err
      alertify.error err
      NProgress.done()
    else
      $name.val('')
      $value.val('')
      aspect.setType(undefined)
      aspect.setName(undefined)
      aspect.setDefId(undefined)
      NProgress.done()



Template.markdownAspectEditor.rendered = ->
  $('textarea.contribute-text').autogrow()

Template.markdownAspectEditor.events
  'click .markdown-aspect.cancel-contribution': (event)->
    $target = $(event.target)
    $target.parents('.edit-section').find('textarea.contribute-text').val('')
    $target.parents('.edit-section').find('.contribute-preview').html('')
    $target.parents('.edit-section').find('.control-group').removeClass('error')

  'submit .markdown-aspect form.contribute-form': (event) ->
    if @id == 'new-aspect'
      handleNewAspect(@, event)
    else
      handleAspectContribution(@, event)
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
    $target = $(event.target)
    $target.parents('.edit-section').find('.control-group').removeClass('error')

  'blur .markdown-aspect .controls button': (event) ->
    $target = $(event.target)
    $target.parents('.edit-section').find('.control-group').removeClass('error')


handleAspectContribution = (aspect, event) ->
  analytics.track('Submit aspect contribution')
  text = $('textarea.contribute-text', event.target).val()
  if text
    NProgress.start()
    Meteor.call 'contributeToAspect', aspect.technology.id, aspect.aspectId, text, (err, ret) ->
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
  $value = $(event.srcElement).find('.contribute-text')
  value = $value.val()
  if not value
    $value.parents('.control-group').addClass('error')
    $value.focus()
    return

  def = aspect.defId()
  analytics.track('add new aspect', {name: name})
  NProgress.start()
  Meteor.call 'contributeNewAspect', aspect.technology.id, name, value, def, (err, ret) ->
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



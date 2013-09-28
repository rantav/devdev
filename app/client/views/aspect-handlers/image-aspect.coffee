Template.imageAspect.image = ->
  url = @imageUrl({h: 30})
  cdned = Cdn.cdnify(url)

Template.imageAspectEditor.rendered = ->
  element = @find('.filepicker-dragdrop')
  element.onchange = (event) ->
    onPickFile(event)
  filepicker.constructWidget(element);

onPickFile = (event) ->
  fpfile = event.fpfile
  $target = $(event.target)
  url = fpfile.url
  resized = url + "/convert?h=30"
  html = "<img src='#{resized}' class='img-polaroid'></img>"
  $target.parents('.edit-section').find('.contribute-preview').html(html)
  $target.parents('.edit-section').find('input[type=hidden]').val(url)

handleNewAspect = (aspect, event) ->
  $name = $('#new-aspect-name')
  name = $name.val()
  if not name
    $name.parents('.control-group').addClass('error')
    $name.focus()
    return
  $value = $('#new-aspect-value')
  value = $value.val()
  if not value
    alertify.error('Please senect an image')
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

Template.imageAspectEditor.events
  'submit .image-aspect form.contribute-form': (event) ->
    if @id() == 'new-aspect'
      handleNewAspect(this, event)
    # return false to prevent browser form submission
    false

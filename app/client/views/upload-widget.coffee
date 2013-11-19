filepicker.setKey("AE9TtsKF3Qpe70XHExHegz")

tool = null
Template.uploadWidget.storePath = ->
  # Abuse ahead :(
  tool = @
  'logos/'

Template.uploadWidget.rendered = ->
  element = @find('.filepicker-dragdrop')
  element.onchange = (event) ->
    onPickFile(event)
  filepicker.constructWidget(element);

onPickFile = (event) ->
  fpfile = event.fpfile
  tool.setLogo(fpfile.url)

filepicker.setKey("AE9TtsKF3Qpe70XHExHegz")

tool = null
Template.logoEditable.storePath = ->
  # Abuse ahead :(
  tool = @
  'logos/'

Template.logoEditable.imgPolaroid = (options) ->
  Html.imgPolaroid(@logoUrl(options.hash))

Template.logoEditable.rendered = ->
  $('[rel=tooltip]').tooltip()
  element = @find('.filepicker')
  if element
    element.onchange = (event) ->
      onPickFile(event)
    filepicker.constructWidget(element);

Template.logoEditable.destroyed = ->
  $('[rel=tooltip]').tooltip('hide')

onPickFile = (event) ->
  fpfile = event.fpfile
  tool.setLogo(fpfile.url)

Template.logoEditable.events
  'click .tool-logo-delete': ->
    @removeLogo('')
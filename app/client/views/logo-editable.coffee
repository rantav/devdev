Template.logoEditable.storePath = -> 'logos/'

Template.logoEditable.imgPolaroid = (options) ->
  Html.imgPolaroid(@logoUrl(options.hash))

Template.logoEditable.rendered = ->
  filepicker.setKey("AE9TtsKF3Qpe70XHExHegz")
  $(@find('[rel=tooltip]')).tooltip()
  element = @find('.filepicker')
  if element
    filepicker.constructWidget(element);

Template.logoEditable.destroyed = ->
  $('[rel=tooltip]').tooltip('hide')

Template.logoEditable.events

  'click .tool-logo-delete': ->
    @removeLogo()

  'change .filepicker': (e) ->
    @setLogo(e.fpfile.url)

window.ImageHandler = class ImageHandler
  type: ->
    'image'
  init: (template) ->
    "ok"
  renderAdder: (aspect, jqPath) ->
    html =
      "<div class='image-aspect edit-section'>
        XXXXX
       </div>"
    if not jqPath then return html
    $(jqPath).html(html)

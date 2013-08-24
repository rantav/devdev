root = exports ? this

root.Html = {}

Html.imgPolaroid = (url) ->
  if not url then return ''
  "<img src='#{url}' class='img-polaroid'></img>"


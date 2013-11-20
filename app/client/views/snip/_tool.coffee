Template._tool.imgPolaroid = (height) ->
  Html.imgPolaroid(@logoUrl({h: height, default: Cdn.cdnify('/img/cogs-47x40.png')}))

Template._tool.rendered = ->
  $(@find('[rel=tooltip]')).tooltip()

Template._tool.destroyed = ->
  $(@find('[rel=tooltip]')).tooltip('hide')

Template._tool.imgPolaroid = (height) ->
  Html.imgPolaroid(@logoUrl({h: height, default: Cdn.cdnify('/img/cogs-47x40.png')}))

Template._tool.inProjectView = -> @currentProject

Template._tool.inProject = -> @currentProject.hasUser(Meteor.userId())

Template._tool.removeTitle = ->
  if @suggested then "Remove #{@name()}" else "Remove #{@name()} from project"

Template._tool.rendered = ->
  $(@find('[rel=tooltip]')).tooltip()

Template._tool.destroyed = ->
  try
    $(@find('[rel=tooltip]')).tooltip('hide')
  catch e

Template._tool.events
  'click .tool-unuse': ->
    @currentProject.setToolUsage(@, false)
    @currentProject.setSuggestedTool(@, false)

  'click .tool-use': ->
    @currentProject.setToolUsage(@, true)
    @currentProject.setSuggestedTool(@, false)

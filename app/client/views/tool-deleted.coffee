Template.toolDeleted.tool = ->
  @tool

Template.toolDeleted.events
  'click #add-tool': (event) ->
    analytics.track('Add tool - tool page', {loggedIn: !!Meteor.userId()})
    name = @tool.name()
    addTool(name)

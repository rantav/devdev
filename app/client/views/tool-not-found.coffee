Template.toolNotFound.toolId = ->
  Session.get('toolId')

Template.toolNotFound.events
  'click #add-tool': (event) ->
    analytics.track('Add tool - tool page', {loggedIn: !!Meteor.userId()})
    name = Session.get('toolId')
    addTool(name)

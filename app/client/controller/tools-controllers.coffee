class @ToolsController extends RouteController
  data:
    page: 'tools'
  waitOn: -> [Meteor.subscribe('tools'), Meteor.subscribe('users')]

class @ToolController extends RouteController

  notFoundTemplate: 'toolNotFound'

  data: ->
    Session.set('toolId', undefined)
    @tool = Tool.findOne(@params.id)
    if not @tool
      Session.set('toolId', @params.id)
      return null

    tool: @tool
    toolId: @params.id
    page: 'tools'

  waitOn: -> Meteor.subscribe('tool', @params.id)


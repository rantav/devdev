class @ToolsController extends RouteController
  data:
    page: 'tools'
    tools: Tool.find({}, {sort: {updatedAt: -1}})

  waitOn: -> [Meteor.subscribe('tools'), Meteor.subscribe('users')]
  after: -> document.title = "#{@data.tools.count()} tools | devdev.io"

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

  after: -> document.title = "#{@tool.name()} | devdev.io"


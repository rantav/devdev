class @ToolsController extends RouteController
  data:
    page: 'tools'

  waitOn: -> subscriptionHandles['tools']

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

  waitOn: -> subscriptionHandles['tools']


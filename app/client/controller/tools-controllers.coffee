class @ToolsController extends RouteController
  data: -> {}
  waitOn: -> subscriptionHandles['tools']

class @ToolController extends RouteController

  run: ->
    t = Tool.findOne(@params.id)
    if t and t.deletedAt()
      @render('toolDeleted')
    else
      @render('tool')

  notFoundTemplate: 'toolNotFound'

  data: ->
    Session.set('toolId', undefined)
    @tool = Tool.findOne(@params.id)
    if not @tool
      Session.set('toolId', @params.id)
      return null
    tool: @tool
    toolId: @params.id

  waitOn: -> subscriptionHandles['tools']


toolsSort = sort: usageCount: -1
class @WelcomeController extends RouteController
  data: ->
    page: 'welcome'
    tools: Tool.find({}, toolsSort)
    users: User.findUsers()
    limit: parseInt(@params.limit || 10)

  waitOn: ->
    limit = @params.limit || 10
    Meteor.subscribe('tools', _.extend({limit: limit}, toolsSort))

  after: ->
    document.title = 'Choose the right tool for the job. Smartly | devdev.io'


toolsSort = sort: updatedAt: -1
class @WelcomeController extends RouteController
  data:
    page: 'welcome'
    tools: Tool.find({}, toolsSort)
    users: User.findUsers()

  waitOn: -> [
    Meteor.subscribe('tools', _.extend({limit: 10}, toolsSort)),
    Meteor.subscribe('users', {limit: 10})]
  after: -> document.title = 'Choose the right tool for the job. Smartly | devdev.io'

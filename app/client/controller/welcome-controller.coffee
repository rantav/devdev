class @WelcomeController extends RouteController
  data:
    page: 'welcome'
    tools: Tool.find({}, {sort: {updatedAt: -1}})
    users: User.findUsers()

  waitOn: -> [Meteor.subscribe('tools'), Meteor.subscribe('users')]
  after: -> document.title = 'Choose the right tool for the job. Smartly | devdev.io'

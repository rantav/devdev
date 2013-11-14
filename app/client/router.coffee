root = exports ? this

Router.map ->
  @route 'welcome', path: '/'

  @route 'about'

  @route 'tools', path: '/tools', controller: 'ToolsController'
  @route 'tool', path: '/tool/:id/:name?', controller: 'ToolController'

  @route 'users', path: '/users', controller: 'UsersController'
  @route 'user', path: '/user/:id/:name?', controller: 'UserController'

  @route 'search', controller: 'SearchController'


Router.configure
  layout: 'layout'
  loadingTemplate: 'loading'

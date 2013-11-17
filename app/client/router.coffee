root = exports ? this

Router.map ->
  @route 'welcome', path: '/'

  @route 'about'

  @route 'tools', path: '/tools', controller: 'ToolsController'
  @route 'tool', path: '/tool/:id/:name?', controller: 'ToolController'
  # Add this for backwards compatibility
  @route 'technology', path: '/technology/:id/:name?', action: -> @redirect(Router.path('tool', {id: @params.id, name: @params.name}))

  @route 'users', path: '/users', controller: 'UsersController'
  @route 'user', path: '/user/:id/:name?', controller: 'UserController'
  # Add this for backwards compatibility
  @route 'contributor', path: '/contributor/:id/:name?', action: -> @redirect(Router.path('user', {id: @params.id, name: @params.name}))

  @route 'search', controller: 'SearchController'


Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

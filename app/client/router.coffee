root = exports ? this

Router.map ->
  @route 'welcome', path: '/'

  @route 'about'

  # @route 'technology', path: '/tool/:id/:name?', action: -> @redirect(Router.path('tool', {id: this.id, name: this.name}))
  @route 'tools', path: '/tools', controller: 'ToolsController'
  @route 'tool', path: '/tool/:id/:name?', controller: 'ToolController'

  @route 'users', path: '/users', controller: 'UsersController'
  @route 'user', path: '/user/:id/:name?', controller: 'UserController'

  @route 'search', controller: 'SearchController'


Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

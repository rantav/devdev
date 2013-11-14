root = exports ? this

Router.map ->
  @route 'welcome', path: '/'

  @route 'about'

  @route 'technologies', controller: 'TechnologiesController'
  @route 'technology', controller: 'TechnologiesController'
  @route 'technology/:id', controller: 'TechnologyController'
  @route 'technology/:id/:name', controller: 'TechnologyController'

  @route 'users', path: '/users', controller: 'UsersController'
  @route 'user', path: '/user/:id/:name?', controller: 'UserController'

  @route 'search', controller: 'SearchController'


Router.configure
  layout: 'layout'
  loadingTemplate: 'loading'

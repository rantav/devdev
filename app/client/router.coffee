root = exports ? this

Router.map ->
  @route 'welcome', path: '/'

  @route 'about'

  @route 'technologies', controller: 'TechnologiesController'
  @route 'technology', controller: 'TechnologiesController'
  @route 'technology', path: '/technology/:id/:name?', controller: 'TechnologyController'

  @route 'contributors', controller: 'ContributorsController'
  @route 'contributor', controller: 'ContributorsController'
  @route 'contributor', path: '/contributor/:id/:name?', controller: 'ContributorController'

  @route 'search', controller: 'SearchController'


Router.configure
  layout: 'layout'
  loadingTemplate: 'loading'

routes = root.routes = {}
routes.technology = (tech) ->
  "/technology/#{tech.id()}/#{tech.name()}" if tech

# routes.contributor = (contributor) ->
#   "/contributor/#{contributor.id()}/#{contributor.name()}" if contributor

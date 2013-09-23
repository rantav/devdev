root = exports ? this

Router.map ->
  @route 'welcome', path: '/'

  @route 'about'

  @route 'technologies', controller: 'TechnologiesController'
  @route 'technology', controller: 'TechnologiesController'
  @route 'technology/:id', controller: 'TechnologyController'
  @route 'technology/:id/:name', controller: 'TechnologyController'

  @route 'contributors', controller: 'ContributorsController'
  @route 'contributor', controller: 'ContributorsController'
  @route 'contributor/:id', controller: 'ContributorController'
  @route 'contributor/:id/:name', controller: 'ContributorController'


Router.configure
  layout: 'layout'
  loadingTemplate: 'loading'

routes = root.routes = {}
routes.technology = (tech) ->
  "/technology/#{tech.id()}/#{tech.name()}" if tech

routes.contributor = (contributor) ->
  "/contributor/#{contributor.id()}/#{contributor.name()}" if contributor

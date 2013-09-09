root = exports ? this

Meteor.Router.add
  '/technology': 'technologies'
  '/technologies': 'technologies'
  "/search":  ->
    Session.set "search", @querystring
    "search"
  "/technology/:id": (id) ->
    Session.set "technologyId", id
    "technology"
  "/technology/:id/:name": (id) ->
    Session.set "technologyId", id
    "technology"
  '/contributor': 'contributors'
  '/contributors': 'contributors'
  "/contributor/:id": (id) ->
    Session.set "contributorId", id
    "contributor"
  "/contributor/:id/:name": (id) ->
    Session.set "contributorId", id
    "contributor"
  '/about': 'about'
  "*": "welcome"


routes = root.routes = {}
routes.technology = (tech) ->
  "/technology/#{tech.id()}/#{tech.name()}" if tech

routes.contributor = (contributor) ->
  "/contributor/#{contributor.id()}/#{contributor.name()}" if contributor

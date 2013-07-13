root = exports ? this

Meteor.Router.add
  '/technology': 'technologies'
  '/technologies': 'technologies'
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
  "*": "welcome"


routes = root.routes = {}
routes.technology = (tech) ->
  "/technology/#{tech._id}/#{tech.name}" if tech

routes.contributor = (contributor) ->
  "/contributor/#{contributor._id}/#{contributor.profile.name}" if contributor

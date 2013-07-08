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
  "*": "welcome"


routes = root.routes = {}
routes.technology = (tech) ->
  "/technology/#{tech._id}/#{tech.name}"
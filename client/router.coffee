Meteor.Router.add
  "/": "welcome"
  "/technology/:id": (id) ->
    Session.set "technologyId", id
    "technology"
  "/technology/:id/:name": (id) ->
    Session.set "technologyId", id
    "technology"
  "*": "welcome"


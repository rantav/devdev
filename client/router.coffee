Meteor.Router.add
  "/": "welcome"
  "/technology/:name": (name) ->
    Session.set "technology", name
    "technology"
  "*": "welcome"


# These are generic view helpers
Handlebars.registerHelper 'loggedIn', (code) ->
  !!Meteor.userId()

Handlebars.registerHelper 'isAdmin', (code) ->
  current = Contributor.current()
  current and current.isAdmin()

# These are generic view helpers
Handlebars.registerHelper 'loggedIn', (code) ->
  !!Meteor.userId()

Handlebars.registerHelper 'isAdmin', (code) ->
  user = Meteor.user()
  user and user.isAdmin()

# Displays a simple "Time ago" string, such as "8 minutes ago", "5 hours ago" etc
Handlebars.registerHelper 'timeAgo', (time) ->
  moment(time).fromNow()


Handlebars.registerHelper 'disableAnonymous', ->
  if Meteor.userId() then "" else "disabled"

Handlebars.registerHelper 'tagLink', (tagName, category) ->
  Url.tagLink(tagName, category)

# Converts markdown to HTML
Handlebars.registerHelper 'marked', (markdown) ->
  marked(markdown)

# Deps.autorun ->
#   window.currentUser = User.current()

# Handlebars.registerHelper 'currentUser', ->
#   currentUser

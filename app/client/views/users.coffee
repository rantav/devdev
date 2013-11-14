Template.users.users = ->
  users = User.findUsers()
  document.title = "#{users.count()} users | devdev.io"
  users

Template.users.imgPolaroid = ->
  Html.imgPolaroid(@logoUrl({h: 15, default: Cdn.cdnify('/img/cogs-17x15.png')}))

Template.users.rendered = ->
  $('.tool-logo-small[rel=tooltip]').tooltip()

Template.users.destroyed = ->
  $('.tool-logo-small[rel=tooltip]').tooltip('hide')

Template.users.users = ->
  users = User.find({}, {sort: {'profile.contributionCount': -1}})
  document.title = "#{users.count()} users | devdev.io"
  users

Template.users.imgPolaroid = ->
  Html.imgPolaroid(@logoUrl({h: 15, default: Cdn.cdnify('/img/cogs-17x15.png')}))

Template.users.rendered = ->
  $('.technology-logo-small[rel=tooltip]').tooltip()

Template.users.destroyed = ->
  $('.technology-logo-small[rel=tooltip]').tooltip('hide')

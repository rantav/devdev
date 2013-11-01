Template.contributors.contributors = ->
  contributors = Contributor.all({}, {sort: {'profile.contributionCount': -1}})
  document.title = "#{contributors.length} contributors | devdev.io"
  contributors

Template.contributors.imgPolaroid = ->
  Html.imgPolaroid(@logoUrl({h: 15, default: Cdn.cdnify('/img/cogs-17x15.png')}))

Template.contributors.rendered = ->
  $('.technology-logo-small[rel=tooltip]').tooltip()

Template.contributors.destroyed = ->
  $('.technology-logo-small[rel=tooltip]').tooltip('hide')

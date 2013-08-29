Template.contributors.contributors = ->
  contributors = Contributor.find({}, {sort: {'profile.contributionCount': -1}})
  document.title = "#{contributors.length} contributors | devdev.io"
  contributors

Template.contributors.rendered = ->
  $('.technology-logo-small[rel=tooltip]').tooltip()

Template.contributors.destroyed = ->
  $('.technology-logo-small[rel=tooltip]').tooltip('hide')

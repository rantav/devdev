Template.contributors.contributors = ->
  contributors = Contributor.find({}, {sort: {'profile.contributionCount': -1}})
  document.title = "#{contributors.length} contributors | devdev.io"
  contributors

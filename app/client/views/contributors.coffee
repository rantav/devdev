Template.contributors.contributors = ->
  contributors = Contributor.find({'profile.contributionCount' : {$gt: 0}},
    {sort: {'profile.contributionCount': -1}})
  document.title = "#{contributors.length} contributors | devdev.io"
  contributors

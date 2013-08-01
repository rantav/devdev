Template.contributors.contributors = ->
  contributors = Contributor.all()
  document.title = "#{contributors.length} contributors | devdev.io"
  contributors

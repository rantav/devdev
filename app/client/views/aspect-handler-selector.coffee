window.markdownHandler = new MarkdownHandler()

window.renderAspectContribution = (aspectContribution) ->
  handler = markdownHandler
  handler.view(aspectContribution)


window.renderAspectEditor = (aspect) ->
  handler = markdownHandler
  handler.renderAdder(aspect)

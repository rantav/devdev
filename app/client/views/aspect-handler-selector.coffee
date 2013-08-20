window.markdownHandler = new MarkdownHandler()

window.renderAspectContribution = (aspectContribution) ->
  handler = markdownHandler
  handler.view(aspectContribution)


window.renderAspectEditor = (aspect) ->
  Deps.autorun ->
    aspect.depend()
    $('#new-aspect-value').attr('placeholder', "Say something about #{aspect.name()}")

  handler = markdownHandler
  handler.renderAdder(aspect)

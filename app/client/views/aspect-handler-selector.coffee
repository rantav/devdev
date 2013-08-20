
window.renderAspectContribution = (aspectContribution) ->
  handler = selectHandler(aspectContribution.aspect())
  handler.view(aspectContribution)


window.renderAspectEditor = (aspect, jqPath) ->
  handler = selectHandler(aspect)
  Deps.autorun ->
    aspect.depend()
    if aspect.type() and handler.type() != aspect.type()
      handler = selectHandler(aspect)
      handler.renderAdder(aspect, jqPath)
    $('#new-aspect-value').attr('placeholder', "Say something about #{aspect.name()}")

  handler.renderAdder(aspect)

window.initHandlers = (template) ->
  markdownHandler.init(template)
  imageHandler.init(template)

markdownHandler = new MarkdownHandler()
imageHandler = new ImageHandler()

selectHandler = (aspect) ->
  if aspect.type() == imageHandler.type()
    return imageHandler
  if aspect.type() == markdownHandler.type()
    return markdownHandler

  # default
  return markdownHandler
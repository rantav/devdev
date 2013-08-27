
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
tagsHandler = new TagsHandler()

handlers = [markdownHandler, imageHandler, tagsHandler]

selectHandler = (aspect) ->
  for handler in handlers
    return handler if handler.type() == aspect.type()

  # default
  return markdownHandler
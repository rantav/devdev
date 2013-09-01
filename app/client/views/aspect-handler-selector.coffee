
window.renderAspectContribution = (aspectContribution, jqPath, readonly) ->
  handler = selectHandler(aspectContribution.aspect())
  handler.view(aspectContribution, jqPath, readonly)


window.renderAspectEditor = (aspect, jqPath) ->
  handler = selectHandler(aspect)
  Deps.autorun ->
    aspect.depend()
    if aspect.type() and handler.type() != aspect.type()
      handler = selectHandler(aspect)
      handler.renderAdder(aspect, jqPath)
    $('#new-aspect-value').attr('placeholder', "Say something about #{aspect.name()}")

  handler.renderAdder(aspect, jqPath)

handlers = [new MarkdownHandler(), new ImageHandler(), new TagsHandler()]

window.initHandlers = (template) ->
  for handler in handlers
    handler.init(template)

selectHandler = (aspect) ->
  for handler in handlers
    return handler if handler.type() == aspect.type()

  # default
  return handlers[0]
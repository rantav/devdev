root = exports ? this

# root.log = Observatory.getToolbox()

root.log =
  error: -> console.error(arguments[0])
  info: -> console.log(arguments[0])
  warn: -> console.warn(arguments[0])

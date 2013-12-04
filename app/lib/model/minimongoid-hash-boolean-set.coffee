class @MinimongoidHashBooleanSet
  constructor: (@collection, @data, @attrPath) ->
    @attrNames = @attrPath.split('.')
  has: (element) =>
    if i = id(element)
      return !!@_getObj()[i]
  elements: => (id for id, value of @_getObj() when value)

  update: (element, exists) =>
    element = id(element)
    update = {}
    update["#{@attrPath}.#{element}"] = exists
    @collection.update({_id: @data._id}, $set: update)

  isEmpty: => @elements().length == 0

  clear: =>
    update = {}
    update["#{@attrPath}"] = {}
    @collection.update({_id: @data._id}, $set: update)

  _getObj: ->
    obj = @data
    for name in @attrNames
      obj = obj[name]
    obj || {}

id = (element) ->
  if element
    return if typeof element == 'string' then element else element.id()

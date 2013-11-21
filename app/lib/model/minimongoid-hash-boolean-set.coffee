class @MinimongoidHashBooleanSet
  constructor: (@collection, @data, @attrPath) ->
    @attrNames = @attrPath.split('.')
  has: (element) =>
    if element
      id = if typeof element == 'string' then element else element.id()
      return !!@_getObj()[id]
  elements: => (id for id, value of @_getObj() when value)

  update: (element, exists) =>
    update = {}
    update["#{@attrPath}.#{element}"] = exists
    @collection.update({_id: @data._id}, $set: update)

  _getObj: ->
    obj = @data
    for name in @attrNames
      obj = obj[name]
    obj || {}


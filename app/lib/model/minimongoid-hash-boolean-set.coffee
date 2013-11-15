class @MinimongoidHashBooleanSet
  constructor: (@collection, @data, @attrPath) ->
    @attrNames = @attrPath.split('.')
  has: (element) => element and @_getObj()[element]
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


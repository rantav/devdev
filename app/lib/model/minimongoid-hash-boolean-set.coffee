class @MinimongoidHashBooleanSet
  constructor: (@collection, @data, @attrName) ->
  has: (element) => element and @data[@attrName] and @data[@attrName][element]
  elements: => (id for id, value of @data[@attrName] when value)
  update: (element, exists) =>
    update = {}
    update["#{@attrName}.#{element}"] = exists
    @collection.update({_id: @data._id}, $set: update)

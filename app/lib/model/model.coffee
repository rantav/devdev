class @Model
  @insert: (data) ->
    @_collection.insert(data)

  constructor: (@data)

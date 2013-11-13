class @Model
  @insert: (data) ->
    @_collection.insert(data)

  @find: (q, opt) ->
    @_collection.find(q, opt)

  constructor: (@data) ->


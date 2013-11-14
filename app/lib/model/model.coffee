class @Model
  @insert: (data) ->
    @_collection.insert(data)

  @find: (q, opt) ->
    @_collection.find(q, opt)

  @findOne: (q, opt) ->
    @_collection.findOne(q, opt)

  constructor: (@data) ->


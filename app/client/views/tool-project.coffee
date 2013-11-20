Template.toolProject.rendered = ->
  if @data.toolNamesSub.ready()
    console.log('ready')

  $(@find('.used-with')).typeahead(
    name: 'accounts',
    local: collectToolSuggestions(@data.currentTool)
  ).bind('typeahead:selected', (obj, datum) ->
    find('.used-with-id').value = datum.id
  )

  # find = @find
  # currentTool = @data.currentTool
  # Meteor.subscribe 'toolNames', ->
  #   console.log(1)
  #   try
  #     $(find('.used-with')).typeahead(
  #       name: 'accounts',
  #       local: collectToolSuggestions(currentTool)
  #     ).bind('typeahead:selected', (obj, datum) ->
  #       console.log(2)
  #       try
  #         find('.used-with-id').value = datum.id
  #       catch e
  #         console.log(e)
  #     )
  #   catch e
  #     console.log(e)


Template.toolProject.destroyed = ->
  console.log('destroyed')

Template.toolProject.tools = ->
  @tools(_id: $ne: @currentTool.id())

Template.toolProject.events
  'keydown .used-with': (event) ->
    enter = event.which == 13
    if enter
      addUsedWith(@, @currentTool)


collectToolSuggestions = (currentTool) ->
  Tool._collection.find({_id: $ne: currentTool.id()}, {transform: null}).map((t) ->
    value: t.name
    id: t._id
  )

addUsedWith = (project, tool) ->
  user = User.current()
  console.log(3)
  try
    withId = $('.used-with-id').val()
    withName = $('.used-with').val()
  catch e
    console.log(e)
  if project.isNew()
    project = Project.create('Project X', user)
  if withId
    addUsedWithId(user, project, tool, withId)

  # TODO: addUsedWithName

addUsedWithId = (user, project, tool, anotherToolId) ->
  anotherTool = Tool.findOne(anotherToolId)
  project.addUserAndTools(user, tool, anotherTool)
  user.setUsingTool(anotherTool, true)
  anotherTool.setUsedBy(user, true)

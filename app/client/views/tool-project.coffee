Template.toolProject.rendered = ->
  find = @find
  $(@find('.used-with')).typeahead(
    name: 'accounts'
    remote: "/typeahead/used-with?pid=#{@data.id()}&q=%QUERY"
  ).bind('typeahead:selected', (obj, datum) ->
    find('.used-with-id').value = datum.id
  )

Template.toolProject.destroyed = ->
  console.log('destroyed')

Template.toolProject.tools = ->
  @tools(_id: $ne: @currentTool.id())

Template.toolProject.events
  'keydown .used-with': (event) ->
    enter = event.which == 13
    if enter
      addUsedWith(@, @currentTool)


addUsedWith = (project, tool) ->
  user = User.current()
  withId = $('.used-with-id').val()
  withName = $('.used-with').val()
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

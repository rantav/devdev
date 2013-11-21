Template.toolProject.rendered = ->
  find = @find
  $(@find('.used-with')).typeahead(
    name: 'accounts'
    remote: "/typeahead/used-with?pid=#{@data.id()}&q=%QUERY"
    template: (datum) ->
      tool = Tool.findOne(datum.id)
      url = tool.logoUrl({h: 20, default: Cdn.cdnify('/img/cogs-17x15.png')})
      [
        "<div class='media'>",
          "<img class='media-object img pull-right' src='#{url}'/>",
          "<div class='media-body'>",
            "<p>#{datum.value}</p>",
          "</div>",
        "</div>"
      ].join('')
  ).bind('typeahead:selected', (obj, datum) ->
    find('.used-with-id').value = datum.id
  )
  @find('.used-with').focus()

Template.toolProject.tools = ->
  currentProject = @
  @tools(_id: $ne: @currentTool.id()).map((t) ->
    t.currentProject = currentProject
    t
  )

Template.toolProject.currentTool = -> @currentTool

Template.toolProject.events
  'keydown .used-with': (event, template) ->
    enter = event.which == 13
    if enter
      withId = template.find('.used-with-id').value
      withName = template.find('.used-with').value
      addUsedWith(@, @currentTool, withId, withName)


addUsedWith = (project, tool, withId, withName) ->
  user = User.current()
  if project.isNew()
    project = Project.create('', user)
  if withId
    addUsedWithId(user, project, tool, withId)

  # TODO: addUsedWithName

addUsedWithId = (user, project, tool, anotherToolId) ->
  anotherTool = Tool.findOne(anotherToolId)
  project.addUserAndTools(user, tool, anotherTool)
  user.setUsingTool(anotherTool, true)
  anotherTool.setUsedBy(user, true)

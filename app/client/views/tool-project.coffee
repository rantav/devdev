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
  $(@find('[rel=tooltip]')).tooltip()

Template.toolProject.tools = ->
  currentProject = @
  @tools(_id: $ne: @currentTool.id()).map((t) ->
    t.currentProject = currentProject
    t
  )

Template.toolProject.currentTool = -> @currentTool

Template.toolProject.usingCurrentTool = ->
  @hasTool(@currentTool)

Template.toolProject.canRemoveProject = ->
  (not @isNew()) and @isCurrentUserOwner()

Template.toolProject.events
  'keydown .used-with': (event, template) ->
    enter = event.which == 13
    if enter
      withId = template.find('.used-with-id').value
      withName = template.find('.used-with').value
      addUsedWith(@, @currentTool, withId, withName)

  'click .remove-project': ->
    @delete()

  'click .use-unuse': ->
    @setToolUsage(@currentTool, not @hasTool(@currentTool))

addUsedWith = (project, tool, withId, withName) ->
  user = User.current()
  if project.isNew()
    project = Project.create('', user)
  if withId
    addUsedWithId(user, project, tool, withId)
    return
  if withName
    addUsedWithName(user, project, tool, withName)

addUsedWithId = (user, project, tool, anotherToolId) ->
  anotherTool = Tool.findOne(anotherToolId)
  project.addUserAndTools(user, tool, anotherTool)
  user.setUsingTool(anotherTool, true)
  anotherTool.setUsedBy(user, true)

addUsedWithName = (user, project, tool, withName) ->
  withName = withName.trim()
  Meteor.call 'resolveToolName', withName, (error, anotherToolId) ->
    # If result is not null then it's the ID this tool was resolved to
    if anotherToolId
      Meteor.call('userUsesTool', user.id(), anotherToolId)
    else
      anotherTool = Tool.create(withName, user)
      anotherTool.setUsedBy(user, true)
      anotherToolId = anotherTool.id()
    project.addUserAndTools(user, tool, anotherToolId)
    user.setUsingTool(anotherToolId, true)



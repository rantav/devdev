Meteor.methods
  indexTool: (toolId) ->
    return
    user = User.current()
    if not user.isAdmin()
      throw new Meteor.Error 401, "Sorry, only admins can do that..."
    tool = Tool.findOne(toolId)
    response = indexer.indexTool(tool.data)
    if response.error then throw new Meteor.Error 500, JSON.stringify(response.error)
    response.result

  indexAllTools: ->
    return
    user = Contributor.current()
    if not user.isAdmin()
      throw new Meteor.Error 401, "Sorry, only admins can do that..."
    tools = (t for t in Tool.find({deletedAt: {$exists: false}}).fetch())
    response = indexer.bulkIndexTools(tools)
    if response.error then throw new Meteor.Error 500, JSON.stringify(response.error)
    response.result
@Helpers = {}
Helpers.useTool = (tool) ->
   if not Meteor.userId(tool)
      alertify.alert(Html.pleasLoginAlertifyHtml())
      return
    user = User.current()
    used = user.isUsingTool(tool)
    tool.setUsedBy(user, not used)
    user.setUsingTool(tool, not used)

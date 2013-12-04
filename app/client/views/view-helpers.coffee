@Helpers = {}
Helpers.useTool = (tool) ->
   if not Meteor.userId(tool)
      alertify.alert(Html.pleasLoginAlertifyHtml())
      return
    user = User.current()
    used = user.isUsingTool(tool)
    tool.setUsedBy(user, not used)
    user.setUsingTool(tool, not used)

Helpers.addTool = (name, opt_user) ->
   if not Meteor.userId()
      alertify.alert(Html.pleasLoginAlertifyHtml())
      return
    user = opt_user || User.current()
    tool = Tool.create(name, user)
    # Use it as a default
    using = true
    tool.setUsedBy(user, using)
    user.setUsingTool(tool, using)
    tool

Meteor.methods
  'resolveToolName': (name) ->
    check(name, String)
    t = Tool.findOne(name, transform: null)
    if t then return t._id

  'userUsesTool': (userId, toolId) ->
    check(userId, String)
    check(toolId, String)
    t = Tool.findOne(toolId)
    if t
      t.setUsedBy(userId, true)
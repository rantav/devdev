HTTP.methods
  '/typeahead/used-with': ->
    @setContentType('application/json')
    q = @query.q
    if not q then return "[]"
    pid = @query.pid
    project = Project.findOne(pid) if pid
    projectToolIds = []
    if project
      projectToolIds = project.tools({}, transform: null).map((t) -> t._id)
    tools = Tool.find({$and: [{_id: {$nin: projectToolIds}}, {'name': new RegExp('^' + q , 'i')}]},
      {transform: null, limit: 10})
    tools = tools.map (t) ->
      id: t._id
      value: t.name
      logo: t.logo
    JSON.stringify(tools)

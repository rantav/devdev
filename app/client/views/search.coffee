tools = []
window.toolsDep = new Deps.Dependency()

window.esCallback = (data) ->
  tools = []
  for hit in data.hits.hits
    tool = Tools.findOne(hit._id)
    tools.push(tool)
  toolsDep.changed()


Template.search.created = ->
  Deps.autorun ->
    query = Session.get('query')
    type = Session.get('type')
    tools = []
    if query
      searcher.search(query, type, 'esCallback')

Template.search.rendered = ->
  query = Session.get('query')
  $('#navbar-search').val(query)

Template.search.tools = ->
  toolsDep.depend()
  document.title = "#{tools.length} tools | devdev.io"
  tools

Template.search.imgPolaroid = ->
  Html.imgPolaroid(@logoUrl({h: 15, default: Cdn.cdnify('/img/cogs-17x15.png')}))

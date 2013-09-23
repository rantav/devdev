technologies = []
window.technologiesDep = new Deps.Dependency()

window.esCallback = (data) ->
  technologies = []
  for hit in data.hits.hits
    tech = Technology.findOne(hit._id)
    technologies.push(tech)
  technologiesDep.changed()


Template.search.created = ->
  query = Session.get('query')
  type = Session.get('type')
  Deps.autorun ->
    technologies = []
    if query
      searcher.search(query, type, 'esCallback')

Template.search.rendered = ->
  query = Session.get('query')
  $('#navbar-search').val(query)

Template.search.technologies = ->
  technologiesDep.depend()
  document.title = "#{technologies.length} technologies | devdev.io"
  technologies

Template.search.imgPolaroid = ->
  Html.imgPolaroid(@logoUrl({h: 15, default: Cdn.cdnify('/img/cogs-17x15.png')}))

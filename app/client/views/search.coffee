technologies = []
window.technologiesDep = new Deps.Dependency()

window.esCallback = (data) ->
  technologies = []
  for hit in data.hits.hits
    tech = Technology.findOne(hit._id)
    technologies.push(tech)
  technologiesDep.changed()


Template.search.created = ->
  Deps.autorun ->
    technologies = []
    search = Session.get('search')
    q = Url.getParameterByName('q', search)
    if q
      type = Url.getParameterByName('type', search)
      searcher.search(q, type, 'esCallback')

Template.search.rendered = ->
  search = Session.get('search')
  q = Url.getParameterByName('q', search)
  $('#navbar-search').val(q)

Template.search.technologies = ->
  technologiesDep.depend()
  document.title = "#{technologies.length} technologies | devdev.io"
  technologies
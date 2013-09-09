technologies = []
window.technologiesDep = new Deps.Dependency()

esSettings = Meteor.settings.public['elastic-search']
esHost = esSettings.host
esPort = esSettings.port
esIndex = esSettings.index
esKey = esSettings['access-key']

window.esCallback = (data) ->
  technologies = []
  for hit in data.hits.hits
    tech = Technology.findOne(hit._id)
    technologies.push(tech)
  technologiesDep.changed()


Template.search.created = ->
  Deps.autorun ->
    search = Session.get('search')
    q = Url.getParameterByName('q', search)
    q = q.replace('tags', 'aspects.contributions.tags')
    type = Url.getParameterByName('type', search)
    apiKey = if esKey then "api-key/#{esKey}/" else ""
    url = "http://#{esHost}:#{esPort}/#{apiKey}#{esIndex}/#{type}/_search?q=#{q}&fields=_id&callback=esCallback"
    $.getScript(url)
    .done((script, textStatus) ->
      # yay!
    )
    .fail((jqxhr, settings, exception) ->
      console.error(exception)
    )


Template.search.technologies = ->
  technologiesDep.depend()
  document.title = "#{technologies.length} technologies | devdev.io"
  technologies


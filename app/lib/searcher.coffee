root = exports ? this

class Searcher
  esSettings = Meteor.settings.public['elastic-search']
  esHost = esSettings.host
  esPort = esSettings.port
  esIndex = esSettings.index
  esKey = esSettings['access-key']

  search: (query, type, callbackName) ->
    apiKey = if esKey then "api-key/#{esKey}/" else ""
    if callbackName
      url = "http://#{esHost}:#{esPort}/#{apiKey}#{esIndex}/#{type}/_search?q=#{query}&fields=_id&callback=#{callbackName}"
      $.getScript(url)
      .done((script, textStatus) ->
        # yay!
      )
      .fail((jqxhr, settings, exception) ->
        console.error(exception)
      )
    else
      throw new Meteor.Error 500, 'We dont support this just yet'

root.searcher = new Searcher()
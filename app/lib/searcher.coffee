root = exports ? this

class Searcher
  esSettings = Meteor.settings.public['elastic-search']
  esHost = esSettings.host
  esPort = esSettings.port
  esIndex = esSettings.index
  esKey = esSettings['access-key']
  apiKey = if esKey then "api-key/#{esKey}/" else ""
  baseUrl = "http://#{esHost}:#{esPort}/#{apiKey}#{esIndex}"
  suggestEnabled = esSettings['suggest-enabled']
  callbackIndex = 0

  search: (query, type, callback) ->
    if callbackName
      url = "#{baseUrl}/#{type}/_search?q=#{query}&fields=_id&callback=#{callbackName}"
      $.getScript(url).done((script, textStatus) ->
        # yay!
      ).fail((jqxhr, settings, exception) ->
        console.error(exception)
      )
    else
      throw new Meteor.Error 500, 'We dont support this just yet'

  tagSuggestLive: (query, category, callback) ->
    return unless suggestEnabled
    if callback
      json = technology:
        text: query
        completion:
          field: "tags_suggest.#{category}"
      source = encodeURIComponent(JSON.stringify(json))
      callbackName = @createNewSuggestCallback(callback)
      url = "#{baseUrl}/_suggest?source=#{source}&callback=#{callbackName}"
      $.getScript(url).done((script, textStatus) ->
        # yay!
      ).fail((jqxhr, settings, exception) ->
        console.error(exception)
      )

  createNewSuggestCallback: (callback) ->
    callbackIndex += 1
    name = 'callback' + callbackIndex
    @[name] = (data) ->
      suggestions = (option.text for option in data.technology[0].options)
      callback(suggestions)
    "searcher.#{name}"

root.searcher = new Searcher()
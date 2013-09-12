root = exports ? this

root.Url = {}

Url.getParameterByName = (name, search) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]?" + name + "=([^&#]*)")
  results = regex.exec(search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))

# @param tag the tag string
# @param category e.g. stack or vertical
Url.tagLink = (tag, category) ->
  tag = '"' + tag + '"'
  "/search?type=technology&q=tags.#{category}:#{tag}"

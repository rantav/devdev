root = exports ? this

root.Url = {}

Url.getParameterByName = (name, search) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]?" + name + "=([^&#]*)")
  results = regex.exec(search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))
root = exports ? this

root.Url = {}

Url.getParameterByName = (name, search) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]?" + name + "=([^&#]*)")
  results = regex.exec(search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))

# provide options as {w: 5, h: 6}
Url.imageUrl = (url, options) ->
  if not url.indexOf('http') == 0 then return null
  w = if options and options.w then "&w=#{options.w}" else ''
  h = if options and options.h then "&h=#{options.h}" else ''
  url = "#{url}/convert?#{w}#{h}&fit=clip&cache=true"
  cdned = Cdn.cdnify(url)

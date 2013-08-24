root = exports ? this

root.Cdn = {}

CDN_ROOT = 'd16azfexq1dof6.cloudfront.net'

Cdn.cdnify = (url) ->
  if not url then return ''
  l = getLocation(url)
  l.hostname = CDN_ROOT
  l.toString()



getLocation = (href) ->
  l = document.createElement('a')
  l.href = href
  l

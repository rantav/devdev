root = exports ? this

root.Cdn = {}

CDN_ROOT = 'd16azfexq1dof6.cloudfront.net'

Cdn.cdnify = (url) ->
  if not url then return ''
  l = getLocation(url)
  l.hostname = CDN_ROOT
  l.port = if l.protocol == 'https:' then 443 else 80
  l.toString()



getLocation = (href) ->
  l = document.createElement('a')
  l.href = href
  l

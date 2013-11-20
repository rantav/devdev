root = exports ? this

root.Cdn = {}

isLocalhost = Meteor.absoluteUrl().indexOf('http://localhost') == 0

CDN_ROOT = 'd16azfexq1dof6.cloudfront.net'

Cdn.cdnify = (url) ->
  if not url then return ''
  if isLocalhost then return url
  l = getLocation(url)
  l.hostname = CDN_ROOT
  l.port = if l.protocol == 'https:' then 443 else 80
  l.toString()



getLocation = (href) ->
  l = document.createElement('a')
  l.href = href
  l

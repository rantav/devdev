Template.setup.rendered = ->
  setupGa()
  ga('send', 'pageview');
  setupNavigation()
  setupDropdowns()

setupGa = ->
  if !window.ga?
    (
      (i, s, o, g, r, a, m) ->
        i['GoogleAnalyticsObject'] = r
        i[r] = i[r] || -> (i[r].q = i[r].q || []).push(arguments)
        i[r].l = 1 * new Date()
        a = s.createElement(o)
        m = s.getElementsByTagName(o)[0]
        a.async = 1
        a.src = g
        m.parentNode.insertBefore(a, m)
    )(window, document, 'script', '//www.google-analytics.com/analytics.js','ga')
    ga('create', 'UA-42577800-1', 'devdev.io')

setupNavigation = ->
  # Highlight the selected navigation item.
  $('ul.nav li a').each( (index, elem) ->
    if document.location.href.indexOf(elem.href) == 0
      $(elem).parent().addClass('active')
    else
      $(elem).parent().removeClass('active')
    )

setupDropdowns = ->
  Meteor.setTimeout (-> $('.dropdown-toggle').dropdown()), 1000

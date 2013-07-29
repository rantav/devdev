Template.setup.rendered = ->
  setupSegmentIo()
  analytics.pageview(document.location.href)
  # setupGa()
  # ga('send', 'pageview',
  #   'page': document.location.pathname,
  #   'location': document.location.href)
  setupNavigation()
  setupDropdowns()

setupSegmentIo = ->
  if !window.analytics?
    # Create a queue, but don't obliterate an existing one!
    window.analytics = [];

    # A list of all the methods we want to generate queueing stubs for.
    methods = ['identify', 'track', 'trackLink', 'trackForm', 'trackClick',
      'trackSubmit','page', 'pageview', 'ab', 'alias', 'ready', 'group']

    # For each of our methods, generate a queueing method that pushes arrays of
    # arguments onto our `analytics` queue. The first element of the array
    # is always the name of the analytics.js method itself (eg. `track`), so that
    # we know where to replay them when analytics.js finally loads.
    factory = (method) ->
      -> analytics.push([method].concat(Array.prototype.slice.call(arguments, 0)))


    i = 0
    while i < methods.length
      analytics[methods[i]] = factory(methods[i])
      i++

    # Define a method that will asynchronously load analytics.js from our CDN.
    analytics.load = (apiKey) ->
      # Create an async script element for analytics.js based on your API key.
      script = document.createElement('script')
      script.type = 'text/javascript'
      script.async = true
      script.src = "//d2dq2ahtl5zl1z.cloudfront.net/analytics.js/v1/#{apiKey}/analytics.min.js"

      # Find the first script element on the page and insert our script next to it.
      firstScript = document.getElementsByTagName('script')[0]
      firstScript.parentNode.insertBefore(script, firstScript)


    # Load analytics.js with your API key, which will automatically load all of the
    # analytics integrations you've turned on for your account. Boosh!
    analytics.load('kqcpdlo36m');
    identify()

# Identifies the user for analytics purpose
identify = ->
  Deps.autorun ->
    if Meteor.userId()
      user = Contributor.current()
      analytics.identify(user.id(),
        name: user.name()
      )

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
    aliases = $(elem).data('hrefAliases')
    href = document.location.href
    if href.indexOf(elem.href) == 0 or (aliases and (alias for alias in aliases.split(' ') when href.indexOf(alias) >= 0).length)
      $(elem).parent().addClass('active')
    else
      $(elem).parent().removeClass('active')
    )

setupDropdowns = ->
  Meteor.setTimeout (-> $('.dropdown-toggle').dropdown()), 1000

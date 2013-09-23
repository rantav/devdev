Template['search-form'].rendered = ->
  $('#navbar-search').val('')

Template['search-form'].events
  'submit #navbar-search-form': (event) ->
    event.preventDefault()
    q = $('#navbar-search').val()
    q = encodeURIComponent(q)
    Router.go("/search?q=#{q}")


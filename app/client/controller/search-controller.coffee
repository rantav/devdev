class @SearchController extends RouteController
  template: 'search'

  data: ->
    Session.set('query', @params.q)
    Session.set('type', @params.type)
    query: @params.q
    type: @params.type



class @TechnologyController extends RouteController
  template: 'technology'
  notFoundTemplate: 'technologyNotFound'

  data: ->
    technology = Technology.findOne(@params.id)
    if not technology
      Session.set('technologyId', @params.id)
      return null
    technology: Technology.findOne(@params.id)
    technologyId: @params.id
    currentUser: Contributor.current()

  waitOn: -> subscriptionHandles['technologies']


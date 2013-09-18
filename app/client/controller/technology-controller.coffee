class @TechnologyController extends RouteController
  template: 'technology'
  notFoundTemplate: 'technologyNotFound'

  data: ->
    @technology = Technology.findOne(@params.id)
    if not @technology
      Session.set('technologyId', @params.id)
      return null
    technology: @technology
    technologyId: @params.id
    currentUser: Contributor.current()

  waitOn: -> subscriptionHandles['technologies']


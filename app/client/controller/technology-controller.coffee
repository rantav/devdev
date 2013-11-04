class @TechnologyController extends RouteController

  run: ->
    t = Technology.find(@params.id)
    if t and t.deletedAt
      @render('technologyDeleted')
    else
      @render('technology')


  notFoundTemplate: 'technologyNotFound'

  data: ->
    Session.set('technologyId', undefined)
    t = Technology.find(@params.id)
    if not t
      Session.set('technologyId', @params.id)
      return null
    technology: t
    technologyId: @params.id
    currentUser: Contributor.current()

  waitOn: -> subscriptionHandles['technologies']


class @TechnologyController extends RouteController

  run: ->
    t = Technology.findOne(@params.id)
    if t and t.deletedAt()
      @render('technologyDeleted')
    else
      @render('technology')


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


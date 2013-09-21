class @TechnologiesController extends RouteController

  data: ->
    currentContributor: Contributor.current()

  waitOn: -> subscriptionHandles['technologies']


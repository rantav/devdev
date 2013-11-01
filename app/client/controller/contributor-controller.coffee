class @ContributorController extends RouteController
  template: 'contributor'
  notFoundTemplate: 'contributorNotFound'

  data: ->
    Session.set('contributorId', undefined)
    @contributor = Contributor.find(@params.id)
    if not @contributor or @contributor.anonymous()
      Session.set('contributorId', @params.id)
      return null
    contributor: @contributor

  waitOn: -> subscriptionHandles['contributors']


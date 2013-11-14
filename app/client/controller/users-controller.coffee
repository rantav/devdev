class @UsersController extends RouteController

  waitOn: -> subscriptionHandles['users']


class @UserController extends RouteController
  template: 'user'
  notFoundTemplate: 'userNotFound'

  data: ->
    Session.set('userId', undefined)
    @user = User.findOne(@params.id)
    if not @user or @user.anonymous()
      Session.set('userId', @params.id)
      return null
    user: @user

  waitOn: -> subscriptionHandles['users']


class @UsersController extends RouteController
  template: 'users'
  waitOn: -> subscriptionHandles['users']
  data:
    page: 'users'


class @UserController extends RouteController
  template: 'user'
  notFoundTemplate: 'userNotFound'

  data: ->
    Session.set('userId', undefined)
    @user = User.findOneUser(@params.id)
    if not @user or @user.anonymous()
      Session.set('userId', @params.id)
      return null
    user: @user
    page: 'users'

  waitOn: -> subscriptionHandles['users']



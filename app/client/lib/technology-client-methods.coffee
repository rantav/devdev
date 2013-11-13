root = exports ? this

root.addTechnology = (name) ->
  if not Meteor.userId()
    alertify.alert(Html.pleasLoginAlertifyHtml())
    return
  Meteor.call 'createNewTechnology', name, (err, ret) ->
    if err
      alertify.error err
      return
    Router.go(routes.technology(Technology.findOne(ret)))
    alertify.success "Great, do you use #{name}? Then click I Use It"

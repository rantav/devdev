Template.technologies.technologies = ->
  technologies = Technology.find({}, {sort: {updatedAt: -1}})
  document.title = "#{technologies.length} technologies | devdev.io"
  technologies

Template.technologies.events
  'click #add-technology': ->
    analytics.track('Add technology', {loggedIn: !!Meteor.userId()})
    if not Meteor.userId()
      alertify.alert('<i class="icon-user icon-4x"> </i> <h2>Please log in</h2>')
      return

    alertify.prompt '<h1>Technology Name:</h1>', (e, str) ->
      if e
        Meteor.call 'createNewTechnology', str, (err, ret) ->
          if err
            alertify.error err
            return
          technology = new Technology(ret)
          Meteor.Router.to technology.route()
          alertify.success "Great, now add some smarts to #{technology.name()}"

  'click i.icon-trash': ->
    analytics.track('Delete technology')
    id = @id()
    name = @name()
    alertify.confirm "<i class='icon-exclamation-sign pull-left icon-4x'> </i><h2>Sure you want to delete #{name}?</h2>", (ok) ->
      if ok
        Meteor.call 'deleteTechnology', id, (err, ret) ->
          if err
            alertify.error err
          else
            alertify.log "OK, deleted #{name}"
      else
        alertify.log "<i class='icon-thumbs-up-alt pull-right'></i> <em>Oh, that was close!...</em>"
  'click .i-use-it': ->
    analytics.track('I use it', {loggedIn: !!Meteor.userId()})
    if not Meteor.userId()
      alertify.alert('<i class="icon-user icon-4x"> </i> <h2>Please log in</h2>')
      return
    current = Contributor.current()
    used = current.isUsingTechnology(@)
    Meteor.call 'iUseIt', @id(), not used, (err, ret) ->
      if err
        alertify.error err

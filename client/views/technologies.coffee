Template.technologies.technologies = ->
  Technologies.find()

Template.technologies.events
  'click #add-technology': ->
    alertify.prompt '<h1>Technology Name:</h1>', (e, str) ->
      if e
        Meteor.call 'createNewTechnology', str, (err, ret) ->
          if err
            alertify.error err
            return
          Meteor.Router.to routes.technology(ret)
          alertify.success "Great, now add some smarts to #{str}"

  'click i.icon-trash': ->
    id = @_id
    alertify.confirm "<i class='icon-exclamation-sign pull-left icon-4x'> </i><h2>Sure you want to delete #{@name}?</h2>", (ok) ->
      if ok
        Meteor.call 'deleteTechnology', id
      else
        alertify.log "<i class='icon-thumbs-up-alt pull-right'></i> <em>Oh, that was close!...</em>"

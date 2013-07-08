Template.technologies.technologies = ->
  Technologies.find()

Template.technologies.events
  'click #add-technology': ->
    alertify.prompt '<h1>Technology Name:</h1>', (e, str) ->
      if e
        Meteor.call 'createNewTechnology', str, (err, ret) ->
          if err
            console.error(err)
            return
          Meteor.Router.to routes.technology(ret)
          alertify.success "Great, now add some smarts to #{str}"



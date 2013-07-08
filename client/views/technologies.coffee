Template.technologies.technologies = ->
  Technologies.find()

Template.technologies.events
  'click #add-technology': ->
    console.log(routes)
    Meteor.call 'createNewTechnology', 'yyy', (err, ret) ->
      if err
        console.error(err)
        return
      document.location = routes.technology(ret)


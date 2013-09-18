Template.technologyNotFound.technologyId = ->
  Session.get('technologyId')

Template.technologyNotFound.events
  'click #add-technology': (event) ->
    analytics.track('Add technology - technology page', {loggedIn: !!Meteor.userId()})
    name = Session.get('technologyId')
    addTechnology(name)

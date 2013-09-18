Template.technologyDeleted.technology = ->
  @technology

Template.technologyDeleted.btnEnabledDisabledClass = ->
  if Meteor.userId() then "" else "disabled"

Template.technologyDeleted.events
  'click #add-technology': (event) ->
    analytics.track('Add technology - technology page', {loggedIn: !!Meteor.userId()})
    name = @technology.name()
    addTechnology(name)

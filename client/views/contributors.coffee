Template.contributors.contributors = ->
  Meteor.users.find()

Template.contributors.countContributions = (contributor)->
  Contributors.getContributions(contributor).length

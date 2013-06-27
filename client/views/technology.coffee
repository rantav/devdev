Template.technology.technology = ->
  Technologies.findOne Session.get("technologyId")

$ ->
  Template.technology.rendered = () ->
    $('.contribution[rel=tooltip]').tooltip() # initialize all tooltips in this template

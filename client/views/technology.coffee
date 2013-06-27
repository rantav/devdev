Template.technology.technology = ->
  Technologies.findOne Session.get("technologyId")

Template.technology.contributors = ->
  technology = Technologies.findOne Session.get("technologyId")
  contributors = [].concat (contribution.contributorId for contribution in aspect.contributions for aspect in technology.aspects)...
  output = {}
  output[contributors[key]] = contributors[key] for key in [0...contributors.length]
  contributors = (value for key, value of output)

$ ->
  Template.technology.rendered = () ->
    $('.contribution[rel=tooltip]').tooltip() # initialize all tooltips in this template

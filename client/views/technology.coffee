Template.technology.technology = ->
  Technologies.findOne Session.get('technologyId')

Template.technology.contributors = ->
  technology = Technologies.findOne Session.get("technologyId")
  contributors = [].concat (contribution.contributorId for contribution in aspect.contributions for aspect in technology.aspects)...
  output = {}
  output[contributors[key]] = contributors[key] for key in [0...contributors.length]
  contributors = (value for key, value of output)

Template.technology.events
  'click .icon-plus': ->
    Meteor.call('toggleContributingAspect', Session.get('technologyId'), @name)

  'click .cancel-contribution': ->
    Meteor.call('endContributingAspect', Session.get('technologyId'), @name)

  'submit form.contribute-form': (event) ->
    text = $('textarea.contribute-text', event.target).val()
    if text
      Meteor.call('contributeToAspect', Session.get('technologyId'), @name, text)
    Meteor.call('endContributingAspect', Session.get('technologyId'), @name)
    # return false to prevent browser form submission
    false

  'keyup textarea.contribute-text': (event) ->
    $target = $(event.target)
    text = $target.val()
    html = marked(text)
    $target.parent().parent().find('.contribute-preview').html(html)

  'click .icon-trash': ->
    Meteor.call('deleteAspectContribution', Session.get('technologyId'), @contributionId)

$ ->
  marked.setOptions
    gfm: true,
    tables: true,
    breaks: true,
    pedantic: false,
    sanitize: true,
    smartLists: true,
    smartypants: false,

  Template.technology.rendered = () ->
    $('.contribution[rel=tooltip]').tooltip() # initialize all tooltips in this template

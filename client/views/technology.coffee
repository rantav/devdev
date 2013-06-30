Template.technology.technology = ->
  # Save the selected technology in the window object for the events to work...
  # Kind of lame, but...
  window.technology = Technologies.findOne Session.get("technologyId")

Template.technology.contributors = ->
  technology = Technologies.findOne Session.get("technologyId")
  contributors = [].concat (contribution.contributorId for contribution in aspect.contributions for aspect in technology.aspects)...
  output = {}
  output[contributors[key]] = contributors[key] for key in [0...contributors.length]
  contributors = (value for key, value of output)

Template.technology.events
  'click .icon-plus': ->
    @['contributing-' + Meteor.userId()] = !@['contributing-' + Meteor.userId()]
    Technologies.update(technology._id, technology)

  'click .cancel-contribution': ->
    @['contributing-' + Meteor.userId()] = false
    Technologies.update(technology._id, technology)

  'submit form.contribute-form': (event) ->
    @['contributing-' + Meteor.userId()] = false
    text = $('textarea.contribute-text', event.target).val()
    if text
      if not @contributions
        @contributions = []
      @contributions.push
        contributorId: Meteor.userId()
        markdown: text
    Technologies.update(technology._id, technology)
    false

  'keyup textarea.contribute-text': (event) ->
    $target = $(event.target)
    text = $target.val()
    html = marked(text)
    $target.parent().parent().find('.contribute-preview').html(html)

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

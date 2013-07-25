Template.technology.technology = ->
  technology = Technology.find  Session.get('technologyId')
  if technology
    document.title = "#{technology.name()} | devdev.io"
  technology

Template.technology.events
  'click .icon-plus': ->
    if Meteor.userId()
      Meteor.call 'toggleContributingAspect', Session.get('technologyId'), @id()
    else
      alertify.alert('<i class="icon-user icon-4x"> </i> <h2>Please log in</h2>')

  'click .cancel-contribution': ->
    Meteor.call('endContributingAspect', Session.get('technologyId'), @id())

  'submit form.contribute-form': (event) ->
    text = $('textarea.contribute-text', event.target).val()
    if text
      Meteor.call 'contributeToAspect', technology.id(), @id(), text, (err, ret) ->
        if err
          alertify.error err
    Meteor.call('endContributingAspect', technology.id(), @id())
    # return false to prevent browser form submission
    false

  'keyup textarea.contribute-text': (event) ->
    $target = $(event.target)
    text = $target.val()
    text = Text.markdownWithSmartLinks(text)
    html = marked(text)
    $target.parent().parent().find('.contribute-preview').html(html)

  'click .icon-trash': ->
    Meteor.call('deleteAspectContribution', technology.id(), @contributionId())

  'click #add-technology': ->
    if not Meteor.userId()
      alertify.alert('<i class="icon-user icon-4x"> </i> <h2>Please log in</h2>')
      return
    name = if technology then technology.name() else Session.get('technologyId')
    console.log(name)
    Meteor.call 'createNewTechnology', name, (err, ret) ->
      if err
        alertify.error err
        return
      Meteor.Router.to routes.technology(Technology.find(ret))
      alertify.success "Great, now add some smarts to #{name}"

  'blur .name': (event, element)->
    name = event.srcElement.innerText
    if name != technology.name()
      Meteor.call 'setName', technology.id(), name, (err, ret) ->
        if err
          alertify.error err
        else
          alertify.success "OK, renamed to #{name}"
          Meteor.Router.to technology.route()


  'click .disabled': (event) ->
    unless event.toElement.className.indexOf('icon-plus') >= 0
      alertify.log '<strong>Coming soonish...</strong> <i class="icon-cogs pull-right"> </i>'


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

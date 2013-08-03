Template.technology.technology = ->
  technology = Technology.findOne(Session.get('technologyId'))
  if technology
    document.title = "#{technology.name()} | devdev.io"
  technology

Template.technology.events
  'click .icon-plus': ->
    analytics.track('Clic add aspect contribution', {loggedIn: !!Meteor.userId()})
    if Meteor.userId()
      Meteor.call 'toggleContributingAspect', Session.get('technologyId'), @id()
    else
      alertify.alert('<i class="icon-user icon-4x"> </i> <h2>Please log in</h2>')

  'click .cancel-contribution': ->
    analytics.track('Cancel aspect contribution')
    Meteor.call('endContributingAspect', Session.get('technologyId'), @id())

  'submit form.contribute-form': (event) ->
    analytics.track('Submit aspect contribution')
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
    analytics.track('Delete aspect contribution')
    Meteor.call('deleteAspectContribution', technology.id(), @contributionId())

  'click #add-technology': (event) ->
    analytics.track('Add technology - technology page', {loggedIn: !!Meteor.userId()})
    if not Meteor.userId()
      alertify.alert('<i class="icon-user icon-4x"> </i> <h2>Please log in</h2>')
      return
    name = if technology then technology.name() else Session.get('technologyId')
    console.log(name)
    Meteor.call 'createNewTechnology', name, (err, ret) ->
      if err
        alertify.error err
        return
      Meteor.Router.to routes.technology(Technology.findOne(ret))
      alertify.success "Great, now add some smarts to #{name}"

  'keyup .name': (event) ->
    esc = event.which == 27
    if esc
      document.execCommand('undo')
      $(event.target).blur()

  'keydown .name': (event) ->
    enter = event.which == 13
    if enter
      $(event.target).blur()
      false

  'blur .name': (event, element)->
    name = event.srcElement.innerText
    if name != technology.name()
      analytics.track('Rename technology')
      Meteor.call 'setName', technology.id(), name, (err, ret) ->
        if err
          alertify.error err
        else
          alertify.success "OK, renamed to #{name}"
          Meteor.Router.to technology.route()


  'click .not-implemented': (event) ->
    alertify.log '<strong>Coming soonish...</strong> <i class="icon-cogs pull-right"> </i>'
    analytics.track('Clicked disabled', {id: event.srcElement.id})


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

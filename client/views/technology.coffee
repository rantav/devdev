Template.technology.technology = -> Technology.find  Session.get('technologyId')

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
      Meteor.call 'contributeToAspect', Session.get('technologyId'), @id(), text, (err, ret) ->
        if err
          alertify.error err
    Meteor.call('endContributingAspect', Session.get('technologyId'), @id())
    # return false to prevent browser form submission
    false

  'keyup textarea.contribute-text': (event) ->
    $target = $(event.target)
    text = $target.val()
    html = marked(text)
    $target.parent().parent().find('.contribute-preview').html(html)

  'click .icon-trash': ->
    Meteor.call('deleteAspectContribution', Session.get('technologyId'), @contributionId())

  'click #add-technology': ->
    if not Meteor.userId()
      alertify.alert('<i class="icon-user icon-4x"> </i> <h2>Please log in</h2>')
      return
    name = Session.get('technologyId')
    Meteor.call 'createNewTechnology', name, (err, ret) ->
      if err
        alertify.error err
        return
      Meteor.Router.to routes.technology(ret)
      alertify.success "Great, now add some smarts to #{name}"

  'click .disabled': (event, element) ->
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

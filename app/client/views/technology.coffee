Template.technology.technology = ->
  technology = Technology.findOne(Session.get('technologyId'))
  if technology
    document.title = "#{technology.name()} | devdev.io"
  window.technology = technology

Template.technology.events
  'click .cancel-contribution': ->
    analytics.track('Cancel aspect contribution')
    $target = $(event.target)
    $target.parent().hide(200)
    $target.parents('.edit-section').find('textarea.contribute-text').val('')
    $target.parents('.edit-section').find('p.contribute-preview').html('')
    $target.parents('.edit-section').find('.control-group').removeClass('error')

  'submit form.contribute-form': (event) ->
    analytics.track('Submit aspect contribution')
    text = $('textarea.contribute-text', event.target).val()
    if text
      Meteor.call 'contributeToAspect', technology.id(), @id(), text, (err, ret) ->
        if err
          alertify.error err
        else
          $target = $(event.target)
          $target.find('textarea.contribute-text').val('')

    # return false to prevent browser form submission
    false

  'click #new-aspect-submit': ->
    $name = $('#new-aspect-name')
    name = $name.val()
    if not name
      $name.parents('.control-group').addClass('error')
      $name.focus()
      return
    $value = $('#new-aspect-value')
    value = $value.val()
    if not value
      $value.parents('.control-group').addClass('error')
      $value.focus()
      return

    analytics.track('add new aspect', {name: name})
    Meteor.call 'contributeNewAspect', technology.id(), name, value, (err, ret) ->
      if err
        alertify.error err
      else
        $name.val('')
        $value.val('')

  'keyup #new-aspect-name': ->
    $name = $('#new-aspect-name')
    name = $name.val()
    if name
      $name.parents('.control-group').removeClass('error')
    else
      $name.parents('.control-group').addClass('error')

  'keyup textarea.contribute-text': (event) ->
    $target = $(event.target)
    text = $target.val()
    text = Text.markdownWithSmartLinks(text)
    text = Text.escapeMarkdown(text)
    html = marked(text)
    $target.parents('.edit-section').find('.contribute-preview').html(html)
    if text
      $target.parents('.control-group').removeClass('error')
    else
      $target.parents('.control-group').addClass('error')


  'blur textarea.contribute-text': (event) ->
    $relatedTarget = $(event.relatedTarget)
    if $relatedTarget.data('referred-id') == event.target.id
      # Don't hide the controls if they have the focus
      return
    $target = $(event.target)
    $target.parents('.edit-section').find('.controls').hide(200)
    $target.parents('.edit-section').find('.control-group').removeClass('error')

  'blur .controls button': (event) ->
    $target = $(event.target)
    if event.relatedTarget
      $relatedTarget = $(event.relatedTarget)
      if $relatedTarget.data('referred-id') == $target.data('referred-id') or event.relatedTarget.id == $target.data('referred-id')
        # Don't hide the controls if they have the focus
        return
    $target.parent().hide(200)
    $target.parents('.edit-section').find('.control-group').removeClass('error')

  'focus textarea.contribute-text': (event) ->
    $target = $(event.target)
    $target.parents('.edit-section').find('.controls').show(200)

  'focus #new-aspect-value': ->
    $name = $('#new-aspect-name')
    name = $name.val()
    if name
      $('#new-aspect-value').attr('placeholder', "Say something about #{name}")
    else
      $('#new-aspect-value').attr('placeholder', "<- Type aspect name first")


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

Template.technology.rendered = ->
  $('.contribution[rel=tooltip]').tooltip() # initialize all tooltips in this template
  refreshAspectNameTypeahead()
  $('input#new-aspect-name').popover
    title: 'Aspect Name'
    content: 'For example: <code>Tagline</code>, or <code>Typical Use Cases</code> etc <hr/> Type <code>?</code> for suggestions'
    html: true
    trigger: 'hover'
    container: 'body'
  $('textarea#new-aspect-value').popover
    title: 'Aspect Value'
    content: 'For example: Link to a website, or tell us what you think about this technology'
    html: true
    trigger: 'hover'


  contributeText = $('textarea.contribute-text')
  if Meteor.userId()
    contributeText.autogrow()

refreshAspectNameTypeahead = ->
  if technology
    suggestions = technology.suggestAspectNames()
    $('input#new-aspect-name').typeahead('destroy')
    $('input#new-aspect-name').typeahead(
      name: 'aspects',
      limit: suggestions.length
      local: suggestions
    ).bind('typeahead:selected', (obj, datum) ->
      $('#new-aspect-value').attr('placeholder', "Say something about #{datum.value}")
    )

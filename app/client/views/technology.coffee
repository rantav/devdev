Template.technology.technology = ->
  technology = Technology.findOne(Session.get('technologyId'))
  if technology
    document.title = "#{technology.name()} | devdev.io"
  window.technology = technology

Template.technology.newAspect = ->
  if not window._newAspect
    window._newAspect = new Aspect({aspectId: 'new-aspect'}, technology)
  window._newAspect

Template.technology.shareText = ->
  "Check out #{technology.name()} on devdev.io, with #{technology.numContributions()} contributions already!"

Template.technology.events

  'keyup #new-aspect-name': ->
    $name = $('#new-aspect-name')
    name = $name.val()
    if name
      $name.parents('.control-group').removeClass('error')
    else
      $name.parents('.control-group').addClass('error')

  'click .icon-trash': ->
    analytics.track('Delete aspect contribution')
    Meteor.call('deleteAspectContribution', technology.id(), @contributionId())

  'click #add-technology': (event) ->
    analytics.track('Add technology - technology page', {loggedIn: !!Meteor.userId()})
    if not Meteor.userId()
      alertify.alert(Html.pleasLoginAlertifyHtml())
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
  'blur #new-aspect-name': ->
    $name = $('#new-aspect-name')
    name = $name.val()
    window._newAspect.type(Technology.typeForName(name))
    window._newAspect.name(name)

  'click .i-use-it': ->
    analytics.track('I use it', {loggedIn: !!Meteor.userId()})
    if not Meteor.userId()
      alertify.alert(Html.pleasLoginAlertifyHtml())
      return
    current = Contributor.current()
    used = current.isUsingTechnology(technology)
    Meteor.call 'iUseIt', technology.id(), not used, (err, ret) ->
      if err
        alertify.error err

  'click #index-technology': ->
    Meteor.call 'indexTechnology', technology.id(), (err, ret) ->
      if err
        alertify.error err
      else
        console.log('indexed. ' + JSON.stringify(ret))

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
  initHandlers(Template.technology)

Template.technology.rendered = ->
  # initialize all tooltips in this template
  $('.contribution[rel=tooltip]').tooltip()
  $('.contributor-dense[rel=tooltip]').tooltip()
  $('.aspect-name[rel=tooltip]').tooltip({container: 'body', placement: 'right'})

  refreshAspectNameTypeahead()
  $('input#new-aspect-name').popover
    title: 'Aspect Name'
    content: 'For example: <code>Tagline</code>, or <code>Typical Use Cases</code> etc <hr/> Type <code>?</code> for suggestions'
    html: true
    trigger: 'hover'
    delay: 200
    container: 'body'
  $('textarea#new-aspect-value').popover
    title: 'Aspect Value'
    content: 'For example: Link to a website, or tell us what you think about this technology'
    html: true
    delay: 200
    trigger: 'hover'
  if technology and technology.isUsedBy(Contributor.current())
    $('.i-use-it').hover(->
      $(@).removeClass('btn-success').addClass('btn-danger').find('.text').html(' Unuse It')
    , ->
      $(@).removeClass('btn-danger').addClass('btn-success').find('.text').html(' I Use It')
    )

Template.technology.destroyed = ->
  $('.contribution[rel=tooltip]').tooltip('hide')
  $('.contributor-dense[rel=tooltip]').tooltip('hide')
  $('.aspect-name[rel=tooltip]').tooltip('hide')
  $('input#new-aspect-name').popover('hide')
  $('input#new-aspect-value').popover('hide')

refreshAspectNameTypeahead = ->
  if technology
    suggestions = technology.suggestAspectNames()
    $('input#new-aspect-name').typeahead('destroy')
    $('input#new-aspect-name').typeahead(
      name: 'aspects',
      limit: suggestions.length,
      local: suggestions
    ).bind('typeahead:selected', (obj, datum) ->
      window._newAspect.type(datum.type)
      window._newAspect.name(datum.value)
      window._newAspect.setDefId(datum.defId)
      help = if datum.defId and aspectDefinitions[datum.defId] and aspectDefinitions[datum.defId].help then aspectDefinitions[datum.defId].help else ''
      $('#new-aspect-help').html(help)

    )

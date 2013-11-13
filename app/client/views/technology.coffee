Template.technology.technology = ->
  if @technology
    document.title = "#{@technology.name()} | devdev.io"
  @technology

Template.technology.synched = ->
  Session.get('devdevFullySynched')

Template.technology.technologyId = ->
  @technologyId

Template.technology.iUseItClass = ->
  if @technology and @technology.isUsedBy(@currentUser) then "btn-success" else ""

Template.technology.twitterShareUrl = ->
  if @technology
    shareText = "Check out #{@technology.name()} on devdev.io"
    "https://twitter.com/share?url=#{encodeURIComponent(document.location.href)}&text=#{encodeURIComponent(shareText)}&via=devdev_io"

Template.technology.imgPolaroid = (options) ->
  if @technology
    Html.imgPolaroid(@technology.logoUrl(options.hash))

newAspect = null
Template.technology.newAspect = ->
  if not newAspect
    newAspect = new Aspect({aspectId: 'new-aspect'}, @technology)
  newAspect.depend()
  newAspect

Template.technology.aspectEditor = (options) ->
  aspect = options.hash.aspect
  jqpath = options.hash.jqpath or '#aspect-edit-' + aspect.id()
  renderAspectEditor(aspect, jqpath)

Template.technology.aspectContributionViewer = (options) ->
  contribution = options.hash.contribution
  jqpath = options.hash.jqpath or '#aspect-view-' + contribution.id()
  renderAspectContribution(contribution, jqpath)

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
    Meteor.call('deleteAspectContribution', @aspect().technology().id(), @contributionId())

  'click #add-technology': (event) ->
    analytics.track('Add technology - technology page', {loggedIn: !!Meteor.userId()})
    name = if @technology then @technology.name() else @technologyId
    addTechnology(name)

  'keyup #technology-name': (event) ->
    esc = event.which == 27
    if esc
      document.execCommand('undo')
      $(event.target).blur()

  'keydown #technology-name': (event) ->
    enter = event.which == 13
    if enter
      $(event.target).blur()
      false

  'blur #technology-name': (event, element)->
    name = event.srcElement.innerText
    if name != @technology.name()
      analytics.track('Rename technology')
      Meteor.call 'setName', @technology.id(), name, (err, ret) ->
        if err
          alertify.error err
        else
          alertify.success "OK, renamed to #{name}"

  'blur #new-aspect-name': ->
    $name = $('#new-aspect-name')
    name = $name.val()
    newAspect.setType(Technology.typeForName(name))
    newAspect.setName(name)
    $('input#new-aspect-name').popover('hide')

  'click .i-use-it': ->
    analytics.track('I use it', {loggedIn: !!Meteor.userId()})
    if not Meteor.userId()
      alertify.alert(Html.pleasLoginAlertifyHtml())
      return
    current = Contributor.current()
    used = current.isUsingTechnology(@technology)
    Meteor.call 'iUseIt', @technology.id(), not used, (err, ret) ->
      if err
        alertify.error err

  'click #index-technology': ->
    Meteor.call 'indexTechnology', @technology.id(), (err, ret) ->
      if err
        alertify.error err
      else
        log.info('indexed. ' + JSON.stringify(ret))

  'click .not-implemented': (event) ->
    alertify.log '<strong>Coming soonish...</strong> <i class="icon-cogs pull-right"> </i>'
    analytics.track('Clicked disabled', {id: event.srcElement.id})

Template.technology.rendered = ->
  # initialize all tooltips in this template
  $('.contributor-dense[rel=tooltip]').tooltip()

  if @data.technology and @data.technology.isUsedBy(@data.currentUser)
    $('.i-use-it').hover(->
      $(@).removeClass('btn-success').addClass('btn-danger').find('.text').html(' Unuse It')
    , ->
      $(@).removeClass('btn-danger').addClass('btn-success').find('.text').html(' I Use It')
    )

Template.technology.destroyed = ->
  $('.contributor-dense[rel=tooltip]').tooltip('hide')

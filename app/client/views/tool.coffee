Template.tool.tool = ->
  @tool

Template.tool.toolId = ->
  @toolId

Template.tool.hasLogo = ->
  if @tool
    @tool.hasLogo()

Template.tool.iUseIt = ->
  @tool and @tool.isUsedBy(User.current())

Template.tool.iUseItClass = ->
  if @tool and @tool.isUsedBy(User.current()) then "btn-success" else ""

Template.tool.twitterShareUrl = ->
  if @tool
    shareText = "Check out #{@tool.name()} on devdev.io"
    "https://twitter.com/share?url=#{encodeURIComponent(document.location.href)}&text=#{encodeURIComponent(shareText)}&via=devdev_io"

Template.tool.imgPolaroid = (options) ->
  if @tool
    Html.imgPolaroid(@tool.logoUrl(options.hash))

Template.tool.projects = ->
  ps = Project.findByUserIdOrTool(Meteor.userId(), @tool.id()).fetch()
  if ps.length == 0
    ps = [Project.new('', u)]
  # ugly hack, I know...
  for p in ps
    p.currentTool = @tool
  tool = @tool
  ps.sort (a, b) ->
    aHas = a.hasTool(tool)
    bHas = b.hasTool(tool)
    if aHas == bHas then return 0
    if aHas then return -1
    if bHas then return 1

Template.tool.displayAddProjectButton = ->
  User.current().projectsWithTool(@tool).count() > 0

Template.tool.events
  'click .icon-trash': ->
    analytics.track('Delete aspect contribution')
    Meteor.call('deleteAspectContribution', @aspect().tool().id(), @contributionId())

  'click #add-tool': (event) ->
    analytics.track('Add tool - tool page', {loggedIn: !!Meteor.userId()})
    name = if @tool then @tool.name() else @toolId
    addTool(name)

  'keyup #tool-name': (event) ->
    esc = event.which == 27
    if esc
      document.execCommand('undo')
      $(event.target).blur()

  'keydown #tool-name': (event) ->
    enter = event.which == 13
    if enter
      $(event.target).blur()
      false

  'blur #tool-name': (event, element)->
    name = event.srcElement.innerText
    if name != @tool.name()
      analytics.track('Rename tool')
      @tool.rename(name)

  'click .i-use-it': ->
    analytics.track('I use it', {loggedIn: !!Meteor.userId()})
    Helpers.useTool(@tool)

  'click #index-tool': ->
    Meteor.call 'indexTool', @tool.id(), (err, ret) ->
      if err
        alertify.error err
      else
        log.info('indexed. ' + JSON.stringify(ret))

  'click .not-implemented': (event) ->
    alertify.log '<strong>Coming soonish...</strong> <i class="icon-cogs pull-right"> </i>'
    analytics.track('Clicked disabled', {id: event.srcElement.id})

  'click #add-project': ->
    project = Project.create('', User.current())
    project.setToolUsage(@tool, true)

Template.tool.rendered = ->
  # initialize all tooltips in this template
  $('.user-dense[rel=tooltip]').tooltip()
  if @data.tool and @data.tool.isUsedBy(User.current())
    $('.i-use-it').hover(->
      $(@).removeClass('btn-success').addClass('btn-danger').find('.text').html(' Unuse It')
    , ->
      $(@).removeClass('btn-danger').addClass('btn-success').find('.text').html(' I Use It')
    )

Template.tool.destroyed = ->
  $('.user-dense[rel=tooltip]').tooltip('hide')

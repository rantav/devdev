Template.tools.tools = ->
  @tools = Tool.find({}, {sort: {updatedAt: -1}})
  document.title = "#{@tools.count()} tools | devdev.io"
  @tools

Template.tools.imgPolaroid = ->
  Html.imgPolaroid(@logoUrl({h: 15, default: Cdn.cdnify('/img/cogs-17x15.png')}))

Template.tools.iUseItClass = () ->
  if @isUsedBy(User.findOneUser(Meteor.userId())) then "btn-success" else ""

Template.tools.events
  'click #add-tool': ->
    analytics.track('Add tool', {loggedIn: !!Meteor.userId()})
    if not Meteor.userId()
      alertify.alert(Html.pleasLoginAlertifyHtml())
      return
    alertify.prompt '<h1>Tool Name:</h1>', (e, str) ->
      if e
        Helpers.addTool(str)

  'click i.icon-trash': ->
    analytics.track('Delete tool')
    id = @id()
    name = @name()
    alertify.confirm "<i class='icon-exclamation-sign pull-left icon-4x'> </i><h2>Sure you want to delete #{name}?</h2>", (ok) =>
      if ok
        @delete()
      else
        alertify.log "<i class='icon-thumbs-up-alt pull-right'></i> <em>Oh, that was close!...</em>"

  'click .i-use-it': ->
    analytics.track('I use it', {loggedIn: !!Meteor.userId()})
    Helpers.useTool(@)

  'click #index-all-tools': ->
    Meteor.call 'indexAlltools', (err, ret) ->
      if err
        alertify.error err
      else
        log.info('indexed. ' + JSON.stringify(ret))

Template.tools.rendered = ->
  $('.user-xsmall[rel=tooltip]').tooltip()

Template.tools.destroyed = ->
  $('.user-xsmall[rel=tooltip]').tooltip('hide')

Template.technologies.technologies = ->
  @technologies = Technology.findUndeleted({}, {sort: {updatedAt: -1}})
  document.title = "#{@technologies.length} technologies | devdev.io"
  @technologies

Template.technologies.imgPolaroid = ->
  Html.imgPolaroid(@logoUrl({h: 15, default: Cdn.cdnify('/img/cogs-17x15.png')}))

Template.technologies.iUseItClass = ->
  if @isUsedBy(Contributor.current()) then "btn-success" else ""

Template.technologies.events
  'click #add-technology': ->
    analytics.track('Add technology', {loggedIn: !!Meteor.userId()})
    alertify.log("Sorry, this is currently disabled, we're working on it...")


  'click .i-use-it': ->
    analytics.track('I use it', {loggedIn: !!Meteor.userId()})
    if not Meteor.userId()
      alertify.alert(Html.pleasLoginAlertifyHtml())
      return
    current = Contributor.current()
    used = current.isUsingTechnology(@)
    Meteor.call 'iUseIt', @id, not used, (err, ret) ->
      if err
        alertify.error err

  'click #index-all-technologies': ->
    Meteor.call 'indexAllTechnologies', (err, ret) ->
      if err
        alertify.error err
      else
        log.info('indexed. ' + JSON.stringify(ret))

Template.technologies.rendered = ->
  $('.contributor-xsmall[rel=tooltip]').tooltip()

Template.technologies.destroyed = ->
  $('.contributor-xsmall[rel=tooltip]').tooltip('hide')

Template.user.user = ->
  document.title = "#{@user.name()} | devdev.io"
  @user

Template.user.imgPolaroid = ->
  Html.imgPolaroid(@logoUrl({h: 15, default: Cdn.cdnify('/img/cogs-17x15.png')}))

Template.user.aspectContributionViewer = (options) ->
  contribution = options.hash.contribution
  renderAspectContribution(contribution, null, true)

Template.user.readonly = ->
  # trick from http://stackoverflow.com/questions/18413457/meteor-template-pass-a-parameter-into-each-sub-template-and-retrieve-it-in-the
  _.extend({readonly: true},this)

Template.user.events
  'click .not-implemented': (event) ->
    alertify.log '<strong>Coming soonish...</strong> <i class="icon-cogs pull-right"> </i>'
    analytics.track('Clicked disabled', {id: event.srcElement.id})

Template.user.rendered = ->
  $('.tool-logo-small[rel=tooltip]').tooltip()

Template.user.destroyed = ->
  $('.tool-logo-small[rel=tooltip]').tooltip('hide')

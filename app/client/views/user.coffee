Template.user.user = -> @user

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

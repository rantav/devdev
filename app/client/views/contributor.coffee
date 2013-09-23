Template.contributor.contributor = ->
  document.title = "#{@contributor.name()} | devdev.io"
  @contributor

Template.contributor.imgPolaroid = ->
  Html.imgPolaroid(@logoUrl({h: 15, default: Cdn.cdnify('/img/cogs-17x15.png')}))

Template.contributor.aspectContributionViewer = (options) ->
  contribution = options.hash.contribution
  renderAspectContribution(contribution, null, true)

Template.contributor.events
  'click .not-implemented': (event) ->
    alertify.log '<strong>Coming soonish...</strong> <i class="icon-cogs pull-right"> </i>'
    analytics.track('Clicked disabled', {id: event.srcElement.id})

Template.contributor.rendered = ->
  $('.technology-logo-small[rel=tooltip]').tooltip()

Template.contributor.destroyed = ->
  $('.technology-logo-small[rel=tooltip]').tooltip('hide')

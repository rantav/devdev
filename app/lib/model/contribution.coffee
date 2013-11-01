class @Contribution extends Minimongoid
  @embedded_in: 'contributor'
  @belongs_to: [{name: 'technology', identifier: 'technologyId'}]

  deleted: -> @deletedAt or @technology().deletedAt or @aspect().deletedAt

  aspect: ->
    @technology().findAspectById(@aspectId)

  content: ->
    @aspect().findContributionById(@contributionId)


  typeIs: (typeStr) -> @type == typeStr

createAspect = (aspectName) ->
  name: aspectName
  contributions: []
  aspectId: Meteor.uuid()


Meteor.methods
  createNewTechnology: (technologyName) ->
    aspectNames = ['Tagline', 'Websites', 'Source Code', 'Typical Use Cases',
        'Sweet Spots', 'Weaknesses', 'Documentation', 'Tutorials', 'StackOverflow',
        'Mailing Lists', 'IRC', 'Development Status', 'Used By', 'Alternatives',
        'Complement Technologies', 'Talks, Videos, Slides', 'Prerequisites',
        'Reviews', 'Developers']

    now = new Date()
    tech =
      name: technologyName
      contributorId: Meteor.userId()
      aspects: []
      createdAt: now
      updatedAt: now
    tech.aspects.push createAspect(a) for a in aspectNames
    _id = Technologies.insert tech
    {_id: _id, name: technologyName}

  contributeToAspect: (technologyId, aspectName, contributionText) ->
    if technologyId and aspectName and contributionText
      technology = Technologies.findOne technologyId
      aspect = Technologies.findAspect(technology, aspectName)
      if not aspect.contributions
        aspect.contributions = []
      now = new Date()
      aspect.contributions.push
        contributorId: Meteor.userId()
        markdown: contributionText
        contributionId: Meteor.uuid()
        createdAt: now
        updatedAt: now
    technology.updatedAt = now
    Technologies.update(technology._id, technology)

  toggleContributingAspect: (technologyId, aspectName) ->
    technology = Technologies.findOne technologyId
    aspect = Technologies.findAspect(technology, aspectName)
    aspect['contributing-' + Meteor.userId()] = !aspect['contributing-' + Meteor.userId()]
    Technologies.update(technologyId, technology)

  endContributingAspect: (technologyId, aspectName) ->
    technology = Technologies.findOne technologyId
    aspect = Technologies.findAspect(technology, aspectName)
    aspect['contributing-' + Meteor.userId()] = false
    Technologies.update(technologyId, technology)

  deleteAspectContribution: (technologyId, contributionId) ->
    technology = Technologies.findOne(technologyId)
    contribution = Technologies.findContribution(technology, contributionId)
    # Permission check
    if contribution.contributorId == Meteor.userId()
      contribution.deletedAt = new Date()
      Technologies.update(technologyId, technology)
    else
      Meteor.error 404, 'Sorry, you cannot delete someone else\'s contribution'

  deleteTechnology: (technologyId) ->
    technology = Technologies.findOne(technologyId)
    # Permission check
    if technology.contributorId == Meteor.userId()
      technology.deletedAt = new Date()
      Technologies.update(technologyId, technology)
    else
      Meteor.error 404, 'Sorry, you cannot delete someone else\'s contribution'

createAspect = (aspectName) ->
  name: aspectName
  contributions: []
  aspectId: Meteor.uuid()

addTechnologyContributionToUser = (technologyId, now) ->
  contributor = Meteor.user()
  if not contributor.profile.contributions
    contributor.profile.contributions = []
  contributor.profile.contributions.push
    technologyId: technologyId
    type: 'technology'
    createdAt: now
    updatedAt: now
  Meteor.users.update(contributor._id, contributor)

addAspectContributionToUser = (technologyId, aspectId, contributionId, now) ->
  contributor = Meteor.user()
  if not contributor.profile.contributions
    contributor.profile.contributions = []
  contributor.profile.contributions.push
    technologyId: technologyId
    aspectId: aspectId
    contributionId: contributionId
    type: 'aspectContribution'
    createdAt: now
    updatedAt: now
  Meteor.users.update(contributor._id, contributor)

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
    addTechnologyContributionToUser _id, now
    {_id: _id, name: technologyName}

  contributeToAspect: (technologyId, aspectName, contributionText) ->
    if technologyId and aspectName and contributionText
      technology = Technologies.findOne technologyId
      aspect = Technologies.findAspectByName(technology, aspectName)
      if not aspect.contributions
        aspect.contributions = []
      now = new Date()
      contributionId = Meteor.uuid()
      aspect.contributions.push
        contributorId: Meteor.userId()
        markdown: contributionText
        contributionId: contributionId
        createdAt: now
        updatedAt: now
    technology.updatedAt = now
    Technologies.update(technology._id, technology)
    addAspectContributionToUser technology._id, aspect.aspectId, contributionId, now

  toggleContributingAspect: (technologyId, aspectName) ->
    technology = Technologies.findOne technologyId
    aspect = Technologies.findAspectByName(technology, aspectName)
    aspect['contributing-' + Meteor.userId()] = !aspect['contributing-' + Meteor.userId()]
    Technologies.update(technologyId, technology)

  endContributingAspect: (technologyId, aspectName) ->
    technology = Technologies.findOne technologyId
    aspect = Technologies.findAspectByName(technology, aspectName)
    aspect['contributing-' + Meteor.userId()] = false
    Technologies.update(technologyId, technology)

  deleteAspectContribution: (technologyId, contributionId) ->
    technology = Technologies.findOne(technologyId)
    contribution = Technologies.findContribution(technology, contributionId)
    # Permission check
    if contribution.contributorId == Meteor.userId()
      now = new Date()
      # Delete contribution
      contribution.deletedAt = now
      Technologies.update(technologyId, technology)
      # Delete from the users's registry
      contributor = Meteor.user()
      userContribution = Contributors.findAspectContribution(contributor, contributionId)
      userContribution.deletedAt = now
      Meteor.users.update(contributor._id, contributor)
    else
      Meteor.error 404, 'Sorry, you cannot delete someone else\'s contribution'

  deleteTechnology: (technologyId) ->
    technology = Technologies.findOne(technologyId)
    # Permission check
    if technology.contributorId == Meteor.userId()
      now = new Date()
      technology.deletedAt = now
      Technologies.update(technologyId, technology)
      # Delete from the users's registry
      contributor = Meteor.user()
      technologyContributions = Contributors.findTechnologyContributions(contributor, technologyId)
      contrib.deletedAt = now for contrib in technologyContributions
      Meteor.users.update(contributor._id, contributor)
    else
      Meteor.error 404, 'Sorry, you cannot delete someone else\'s contribution'

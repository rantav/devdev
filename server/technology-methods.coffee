createAspect = (aspectName) ->
  name: aspectName
  contributions: []


Meteor.methods
  createNewTechnology: (technologyName) ->
    aspectNames = ['Tagline', 'Websites', 'Source Code', 'Typical Use Cases',
        'Sweet Spots', 'Weaknesses', 'Documentation', 'Tutorials', 'StackOverflow',
        'Mailing Lists', 'IRC', 'Development Status', 'Used By', 'Alternatives',
        'Complement Technologies', 'Talks, Videos, Slides', 'Prerequisites',
        'Reviews', 'Developers']

    tech =
      name: technologyName
      contributorId: Meteor.userId()
      aspects: []
    tech.aspects.push createAspect(a) for a in aspectNames
    _id = Technologies.insert tech
    {_id: _id, name: technologyName}


createAspect = (aspectName) ->
  name: aspectName
  contributions: []


Meteor.methods
  createNewTechnology: (technologyName) ->
    tech =
      name: technologyName
      aspects: [
        createAspect 'Tagline'
      ,
        createAspect 'Websites'
      ,
        createAspect 'Source Code'
      ,
        createAspect 'Typical Use Cases'
      ,
        createAspect 'Sweet Spots'
      ,
        createAspect 'Weaknesses'
      ,
        createAspect 'Documentation'
      ,
        createAspect 'Tutorials'
      ,
        createAspect 'StackOverflow'
      ,
        createAspect 'Mailing Lists'
      ,
        createAspect 'IRC'
      ,
        createAspect 'Development Status'
      ,
        createAspect 'Used By'
      ,
        createAspect 'Alternatives'
      ,
        createAspect 'Complement Technologies'
      ,
        createAspect 'Talks, Videos, Slides'
      ,
        createAspect 'Prerequisites'
      ,
        createAspect 'Reviews'
      ,
        createAspect 'Developers'
      ]
    _id = Technologies.insert tech
    {_id: _id, name: technologyName}


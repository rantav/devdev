root = exports ? this

Technologies = root.Technologies = new Meteor.Collection "technogies"

createAspect = (aspectName) ->
  name: aspectName
  contributions: []

Technologies.createNew = (technologyName) ->
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

if Meteor.isServer
  ran = Meteor.users.findOne {'profile.name': 'Ran Tavory'}
  yael = Meteor.users.findOne {'profile.name': 'Yael Tavory'}
  if ran and not ran.profile.color
    ran.profile.color = '#a979d9'
    # unused color: rgb(255, 177, 177)
    Meteor.users.update ran._id, ran
  if Technologies.find().count() is 0 and ran and yael
    technologies = [
      Technologies.createNew 'MeteorJS'
    ]
    _.each technologies, (technology) ->
      Technologies.insert technology

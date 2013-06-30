root = exports ? this

root.Technologies = new Meteor.Collection "technogies"

if Meteor.isServer
  ran = Meteor.users.findOne {'profile.name': 'Ran Tavory'}
  yael = Meteor.users.findOne {'profile.name': 'Yael Tavory'}
  if ran and not ran.profile.color
    ran.profile.color = '#a979d9'
    # unused color: rgb(255, 177, 177)
    Meteor.users.update ran._id, ran
  if Technologies.find().count() is 0 and ran and yael
    technologies = [
      name: "MeteorJS"
      aspects: [
        name: 'Tagline'
        contributions: [
          contributorId: ran._id
          markdown: 'A better way to build apps.'
        ,
          contributorId: yael._id
          markdown: 'A really good way to build apps, daddy!'
        ]
      ,
        name: 'Websites'
        contributions: [
          contributorId: ran._id
          markdown: '<a href="http://www.meteor.com">http://www.meteor.com</a>'
        ,
          contributorId: ran._id
          markdown: '<a href="https://github.com/meteor/meteor">https://github.com/meteor/meteor</a>'
        ]
      ]
    ,
    ]
    _.each technologies, (technology) ->
      Technologies.insert technology

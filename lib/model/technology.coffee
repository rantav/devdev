root = exports ? this

root.Technologies = new Meteor.Collection "technogies"
if Meteor.isServer and Technologies.find().count() is 0
  technologies = [
    name: "MeteorJS"
    aspects: [
      name: 'Tagline'
      contributions: [
        contributor:
          name: 'Ran Tavory'
          id: 1
        html: 'A better way to build apps.'
      ,
        contributor:
          name: 'Yael Tavory'
          id: 2
        html: 'A really good way to build apps, daddy!'
      ]
    ,
      name: 'Websites'
      contributions: [
        contributor:
          name: 'Ran Tavory'
          id: 1
        html: '<a href="http://www.meteor.com">http://www.meteor.com</a>'
      ,
        contributor:
          name: 'Ran Tavory'
          id: 1
        html: '<a href="https://github.com/meteor/meteor">https://github.com/meteor/meteor</a>'
      ]
    ]
  ,
  ]
  _.each technologies, (technology) ->
    Technologies.insert technology

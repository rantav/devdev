ToolsCollection = Technologies # Will rename later...


Meteor.startup ->
  Meteor.Migrations.add 'move logo', (log) ->
    ToolsCollection.find().forEach (t) ->
      logo = null
      for aspect in t.aspects
        if aspect.name == 'Logo'
          contributions = aspect.contributions || aspect.aspectContributions
          if contributions
            logo = contributions[0].content
            break
      if logo
        ToolsCollection.update({_id: t._id}, {$set: {logo: logo}})
        log.info("#{t.name}: #{logo}")


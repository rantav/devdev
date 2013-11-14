
Meteor.startup ->

  Meteor.Migrations.add 'move logo', (log) ->
    Technologies.find().forEach (t) ->
      logo = null
      for aspect in t.aspects
        if aspect.name == 'Logo'
          contributions = aspect.contributions || aspect.aspectContributions
          if contributions
            logo = contributions[0].content
            break
      if logo
        Technologies.update({_id: t._id}, {$set: {logo: logo}})
        log.info("#{t.name}: #{logo}")

  Meteor.Migrations.add 'copy technologies -> tools', (log) ->
    Technologies.find().forEach (t) ->
      Tool.insert(t)
      log.info("Inserted #{t._id}: #{t.name}")

  Meteor.Migrations.add 'cleanup tools data', ((log) ->
    Tool._collection.find().forEach (t) ->
      delete t.data.aspects
      Tool._collection.update(t.data._id, t.data)
      log.info("Cleaned #{t.data._id}"))

  Meteor.Migrations.add 'Tool.contributorId -> creatorId', ((log) ->
    Tool._collection.find().forEach (t) ->
      t.data.creatorId = t.data.contributorId
      delete t.data.contributorId
      Tool._collection.update(t.data._id, t.data)
      log.info("Renamed to creatorId #{t.data._id}: #{t.data.creatorId}"))

Technologies = new Meteor.Collection('technologies')
Meteor.startup ->

  if process.env.METEOR_MIGRATIONS_OFF
    return

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

  Meteor.Migrations.add 'User.profile.usingTechnology -> usingTool', ((log) ->
    User.find().forEach (u) ->
      u.profile.usingTool = u.profile.usingTechnology
      delete u.profile.usingTechnology
      User._collection.update(u._id, u)
      log.info("Updated usingTool #{u._id}"))

  Meteor.Migrations.add 'remove User.profile.contributions and contributionCount', ((log) ->
    User.find().forEach (u) ->
      delete u.profile.contributions
      delete u.profile.contributionCount
      User._collection.update(u._id, u)
      log.info("Deleted from #{u._id}"))

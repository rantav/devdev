log = new Logger('startup');
Meteor.startup ->

  if process.env.METEOR_MIGRATIONS_OFF
    log.info("METEOR_MIGRATIONS_OFF is set, will not run migrations")
    return

  # Meteor.Migrations.add 'remove User.profile.contributions and contributionCount', ((log) ->
  #   User.find().forEach (u) ->
  #     delete u.profile.contributions
  #     delete u.profile.contributionCount
  #     User._collection.update(u._id, u)
  #     log.info("Deleted from #{u._id}"))

  Meteor.Migrations.add 'calculate usageCount for tools', ((log) ->
    Tool.find().forEach (t) ->
      usageCount = t.usedByCount()
      Tool._collection.update({_id: t.id()}, {$set: {usageCount: usageCount}})
      log.info("Updated usageCount for #{t.id()} to #{usageCount}"))

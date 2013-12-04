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

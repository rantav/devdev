Meteor.startup ->
  Meteor.Migrations.add 'Contributor.profile.contributions -> Contributor.contributions', (log) -> 
    Meteor.users.find().forEach (u) ->
      if (! u.contributions)
        u.contributions = u.profile.contributions
        log.info("Updating user #{u._id}")
        Meteor.users.update(_id: u._id, u)



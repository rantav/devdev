Meteor.startup ->
  # Move all Contributor.profile.contributions to Contributor.contributions.
  # This will make the work with embedded documents much easier
  Meteor.Migrations.add 'Contributor.profile.contributions -> Contributor.contributions', (log) ->
    Meteor.users.find().forEach (u) ->
      if (! u.contributions)
        u.contributions = u.profile.contributions
        log.info("Updating user #{u._id}")
        Meteor.users.update(_id: u._id, u)

  # Deletes all user contributions that were marked as deleted. Actually delete them
  Meteor.Migrations.add 'Prune user contributions', (log) ->
    Meteor.users.find().forEach (u) ->
      contributions = []
      for contribution in u.contributions
        if not contribution.deletedAt
          contributions.push(contribution)
      log.info("User #{u._id} before: #{u.contributions.length}  after: #{contributions.length}")
      if u.contributions.length != contributions.length
        u.contributions = contributions
        Meteor.users.update({_id: id}, u)

  # Prune all contributions to technologies that were already deleted
  Meteor.Migrations.add 'Prune technology contributions', (log) ->
    Meteor.users.find().forEach (u) ->
      contributions = []
      for contribution in u.contributions
        t = Technology._collection.findOne({_id: contribution.technologyId})
        if t and not t.deletedAt
          contributions.push(contribution)
      log.info("User #{u._id} before: #{u.contributions.length}  after: #{contributions.length}")
      if u.contributions.length != contributions.length
        u.contributions = contributions
        Meteor.users.update({_id: id}, u)

  # Change all Aspect.contributions to Aspect.aspectContributions
  Meteor.Migrations.add 'Aspect.contributions -> Aspect.aspectContributions', (log) ->
    Technology._collection.find().forEach (t) ->
      for aspect in t.aspects
        modified = false
        if not aspect.aspectContributions
          aspect.aspectContributions = aspect.contributions
          delete aspect.contributions
          modified = true

        if modified
          db.technologies.save(t);

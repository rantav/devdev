db.users.find().forEach(function(u) {
  u.profile.contributions = [];
  db.users.save(u);
})

db.technologies.find().forEach(function(t){
  var creator = db.users.findOne({_id: t.contributorId});
  if (creator) {
    creator.profile.contributions.push({
        technologyId: t._id,
        type: 'technology',
        createdAt: t.createdAt,
        updatedAt: t.updatedAt
    });
    db.users.save(creator);
  }
})

db.technologies.find().forEach(function(t){
  for (var a = 0; a < t.aspects.length; ++a) {
    var aspect = t.aspects[a];
    for (var c = 0; c < aspect.contributions.length; ++c) {
      var contribution = aspect.contributions[c];
      var contributor = db.users.findOne({_id: contribution.contributorId});
      if (contributor) {
        contributor.profile.contributions.push({
            technologyId: t._id,
            aspectId: aspect.aspectId,
            contributionId: contribution.contributionId,
            type: 'aspectContribution',
            createdAt: contribution.createdAt,
            updatedAt: contribution.updatedAt
        });
        db.users.save(contributor);
      }
    }
  }
})

// Update the number of contributions
db.users.find().forEach(function(u) {
  var contributions = u.profile.contributions;
  var count = 0;
  for (var i= 0; i < contributions.length; ++i) {
    if (!contributions[i].deletedAt) {
      ++count;
    }
  }
  u.profile.contributionCount = count;
  db.users.save(u);
})

// Prune unused aspects
db.technologies.find().forEach(function(t){
  var newAspects = [];
  for (var a = 0; a < t.aspects.length; ++a) {
    var aspect = t.aspects[a];
    if (aspect.contributions.length > 0) {
      newAspects.push(aspect);
    }
  }
  t.aspects = newAspects;
  db.technologies.save(t);
})


// Convert mardown to content:
db.technologies.find().forEach(function(t){
  for (var a = 0; a < t.aspects.length; ++a) {
    var aspect = t.aspects[a];
    for (var c = 0; c < aspect.contributions.length; ++c) {
      contribution = aspect.contributions[c];
      if (!contribution.content) {
        contribution.content = contribution.markdown;
        delete contribution.markdown;
      }
    }
  }
  db.technologies.save(t);
})

// Convert content to tags
db.technologies.find().forEach(function(t){
  for (var a = 0; a < t.aspects.length; ++a) {
    var aspect = t.aspects[a];
    if (aspect.type == 'tags') {
      for (var c = 0; c < aspect.contributions.length; ++c) {
        contribution = aspect.contributions[c];
        contribution.tags = contribution.content.split(',')
        for (var ta = 0; ta < contribution.tags.length; ++ta) {
          contribution.tags[ta] = contribution.tags[ta].trim();
        }
      }
    }
  }
  db.technologies.save(t);
})

// Change Websites to Website
db.technologies.find().forEach(function(t){
  for (var a = 0; a < t.aspects.length; ++a) {
    var aspect = t.aspects[a];
    if (aspect.name == 'Websites') {
      aspect.name = 'Website';
      print(t.name);
    }
  }
  db.technologies.save(t);
})


// Add defId to aspects
db.technologies.find().forEach(function(t){
  for (var a = 0; a < t.aspects.length; ++a) {
    var aspect = t.aspects[a];
    if (!aspect.defId) {
      aspect.defId = aspect.name.toLowerCase();
      print(t.name + ': ' + aspect.name);
    }
  }
  db.technologies.save(t);
})

// Delete contributing-xxx
db.technologies.find().forEach(function(t){
  for (var a = 0; a < t.aspects.length; ++a) {
    var aspect = t.aspects[a];
    for (var i in aspect) {
      if (i.indexOf('contributing-') == 0) {
        print(i);
        delete aspect[i]
      }
    }
  }
  db.technologies.save(t);
})

// Add types to aspects
db.technologies.find().forEach(function(t){
  for (var a = 0; a < t.aspects.length; ++a) {
    var aspect = t.aspects[a];
    if (!aspect.type) {
      aspect.type = 'markdown';
    }
   print(aspect.name + ': ' + aspect.type);
  }
  db.technologies.save(t);
})


Move to Minimongoid
===================

// Move all Contributor.profile.contributions to Contributor.contributions.
// This will make the work with embedded documents much easier
db.users.find().forEach(function(u) {
  if (! u.contributions) {
    u.contributions = u.profile.contributions;
    db.users.save(u);
  }
})

// Deleted all user contributions that were marked as deleted. Actually delete them
db.users.find().forEach(function(u) {
  contributions = [];
  for (var i = 0; i < u.contributions.length; ++i) {
    if (!u.contributions[i].deletedAt) {
      contributions.push(u.contributions[i]);
    }
  }
  print(u.contributions.length);
  print(contributions.length);
  u.contributions = contributions;
  db.users.save(u);
})

// Prune all contributions to technologies that were already deleted
db.users.find().forEach(function(u) {
  contributions = [];
  for (var i = 0; i < u.contributions.length; ++i) {
    var t = db.technologies.findOne({_id: u.contributions[i].technologyId});
    if (t && !t.deletedAt) {
      contributions.push(u.contributions[i]);
    }
  }
  print(u.contributions.length);
  print(contributions.length);
  u.contributions = contributions;
  db.users.save(u);
})

// Change all Aspect.contributions to Aspect.aspectContributions
db.technologies.find().forEach(function(t){
  for (var a = 0; a < t.aspects.length; ++a) {
    var aspect = t.aspects[a];
    aspect.aspectContributions = aspect.contributions;
    delete aspect.contributions;
  }
  db.technologies.save(t);
})



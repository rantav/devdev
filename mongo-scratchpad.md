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


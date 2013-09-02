elasticsearch = Meteor.require('elasticsearch')

config =
  _index: 'kittehs'

es = elasticsearch(config)

# console.log('===== BEFORE')
# Meteor.sync((done) ->
#   es.search(
#     query:
#       field:
#         animal: 'kitteh'
#     , (err, data) ->
#       console.error(err)
#       console.log(data)
#       done()
#   )
# )

# console.log('==== AFTER')

Meteor.methods
  indexTechnology: (technologyId) ->
    technology = Technology.findOne(technologyId)
    console.log(technology)
    technology
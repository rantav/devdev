# https://github.com/matb33/meteor-collection-hooks/tree/v0.3.2
Technologies.after 'update', (userId, docId, fieldNames, modifier) ->
  if fieldNames.deletedAt
    indexer.removeTechnology(docId)
  else
    indexer.indexTechnology(fieldNames)

Technologies.after 'insert', (userId, doc) ->
  indexer.indexTechnology(doc)

Technologies.after 'delete', (userId, docId) ->
  indexer.removeTechnology(docId)

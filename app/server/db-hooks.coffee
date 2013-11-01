# https://github.com/matb33/meteor-collection-hooks/tree/v0.3.2
Technology._collection.after 'update', (userId, docId, fieldNames, modifier) ->
  if fieldNames.deletedAt
    indexer.removeTechnology(docId)
  else
    indexer.indexTechnology(fieldNames)

Technology._collection.after 'insert', (userId, doc) ->
  indexer.indexTechnology(doc)

Technology._collection.after 'delete', (userId, docId) ->
  indexer.removeTechnology(docId)

# https://github.com/matb33/meteor-collection-hooks/tree/v0.3.2
Tool._collection.after 'update', (userId, docId, fieldNames, modifier) ->
  if fieldNames.deletedAt
    indexer.removeTool(docId)
  else
    indexer.indexTool(fieldNames)

Tool._collection.after 'insert', (userId, doc) ->
  indexer.indexTool(doc)

Tool._collection.after 'delete', (userId, docId) ->
  indexer.removeTool(docId)

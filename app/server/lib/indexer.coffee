root = exports ? this
log = new Logger('indexer')
class Indexer

  elasticsearch = Meteor.require('elasticsearch')
  settings = Meteor.settings.public['elastic-search']
  priv = Meteor.settings['elastic-search']
  suggestEnabled = settings['suggest-enabled']
  if settings
    log.trace('Will connect to ES at ' + settings.host + ':' + settings.port + '  Using index: ' + settings.index)
    conf =
      _index: settings.index
      _type: 'tool'
      server:
        host: settings.host
        port: settings.port
    if priv.auth then conf.server.auth = priv.auth
    tools = elasticsearch(conf)


  init: ->
    @mapTools()

  # Initializes the tools document mapping
  mapTools: ->
    return
    # TODO
    options = {}
    mapping =
      technology:
        properties:
          aspects:
            properties:
              aspectId:
                type: "string"
              contributions:
                properties:
                  content:
                    type: "string"
                  contributionId:
                    type: "string"
                  contributorId:
                    type: "string"
                  createdAt:
                    type: "date",
                    format: "dateOptionalTime"
                  deletedAt:
                    type: "date",
                    format: "dateOptionalTime"
                  updatedAt:
                    type: "date",
                    format: "dateOptionalTime"
              defId:
                type: "string"
              name:
                type: "string"
              type:
                type: "string"
          contributorId:
            type: "string"
          createdAt:
            type: "date",
            format: "dateOptionalTime"
          name:
            type: "string"
          tags:
            properties:
              stack:
                type: "string"
              vertical:
                type: "string"
          updatedAt:
            type: "date",
            format: "dateOptionalTime"
          usedBy:
            type: "string"

    if suggestEnabled
      mapping.Tool.properties.tags_suggest =
        type: "object"
        properties:
          vertical:
            type: "completion"
          stack:
            type: "completion"

    Meteor.sync((done) ->
      tools.indices.putMapping(options, mapping, (err, data) ->
        if err
          log.error(err)
          done(err)
        else
          log.trace('ES Mapping success.')
          done(null, data)
      )
    )

  indexTool: (techData) ->
    return

    techData = @prepare(techData)
    Meteor.sync((done) ->
      tools.index({_id: techData._id}, techData, (err, data) ->
        if err
          log.error(err)
          done(err)
        else
          log.trace("ES Index success.")
          done(null, data)
      )
    )

  bulkIndexTools: (techDatas) ->
    return

    techDatas = (@prepare(t) for t in techDatas)
    options = {}
    Meteor.sync((done) =>
      @bulkIndex(tools, options, techDatas, (err, data) ->
        if err
          log.error(err)
          done(err)
        else
          log.trace("ES Index success.")
          done(null, data)
      )
    )

  # Creating my own version of bulkIndex since the one implemented here
  # doesn't play nice with document's _id's
  bulkIndex: (index, options, documents, callback) ->
    if not callback and typeof documents is "function"
      callback = documents
      documents = options
      options = {}
    return callback(new Error("documents provided must be in array format")) unless Array.isArray(documents)
    commands = []
    documents.forEach (doc) ->
      docConfig = index:
        _index: conf._index
        _type: conf._type
      if doc._id then docConfig.index._id = doc._id
      commands.push(docConfig)
      commands.push(doc)

    index.bulk(options, commands, callback)

  removeTool: (techId) ->
    Meteor.sync((done) ->
      tools.delete({_id: techId}, (err, data) ->
        if err
          log.error(err)
          done(err)
        else
          log.trace("Delete success. " + data)
          done(null, data)
      )
    )

  # Prepares the document for indexing
  prepare: (doc) ->
    doc = _.extend({}, doc)
    @removeDeleted(doc)
    @removeNoIndex(doc)
    @extractTags(doc)
    if suggestEnabled
      @extractSuggestionTags(doc)
    @refactorUsedBy(doc)
    doc

  # Removes contributions marked as deletedAt (or entire documents marked as so)
  removeDeleted: (doc) ->
    if doc.deletedAt
      delete doc.name
      delete doc.aspects
      delete doc.contributorId
      delete doc.usedBy
      return
    for aspect in doc.aspects
      newContributions = []
      for contribution in aspect.contributions
        if not contribution.deletedAt
          newContributions.push contribution
      aspect.contributions = newContributions


  # Refactors the usedBy map {userId: boolean} into an array [userId1, userId2]
  refactorUsedBy: (doc) ->
    doc.usedBy = (userId for userId, used of doc.usedBy when used)

  # digs into the techData and pulls the tags up so they are easily indexed
  # and more naturally used while searching
  extractTags: (doc) ->
    tags = {}
    defs = ['vertical', 'stack']
    for d in defs
      tags[d] = []
    for aspect in doc.aspects
      if aspect.defId in defs
        for contribution in aspect.contributions
          for tag in contribution.tags
            if tag
              tags[aspect.defId].push(tag)
          delete contribution.tags
    for d in defs
      tags[d] = _.uniq(tags[d])
    doc.tags = tags

  extractSuggestionTags: (doc) ->
    doc.tags_suggest = _.extend({}, doc.tags)

root.indexer = new Indexer()
root.indexer.init()

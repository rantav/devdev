Meteor.methods
  'suggestUsedTools': (url) ->
    analyzer.getUsedTools(url)

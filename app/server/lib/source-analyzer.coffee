lister = Meteor.require('node-github-list-packages')

log = new Logger('source-analyzer')

getUsedPackages = Async.wrap(lister.getUsedPackages)


@analyzer =
  getUsedTools: (repoUrl) ->
    getUsedPackages(repoUrl)

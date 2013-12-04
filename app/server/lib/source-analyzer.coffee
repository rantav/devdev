lister = Meteor.require('node-github-list-packages')

log = new Logger('source-analyzer')

getUsedPackages = Async.wrap(lister.getUsedPackages)


@analyzer =
  getUsedTools: (repoUrl) ->
    packages = analyzer.getPackages(repoUrl)
    # See if some of the packages are already in the database. Assign IDs to them if they are
    names = _.pluck(packages, 'name')
    regexp = new RegExp("^#{names.join('$|^')}$", 'i')
    found = Tool.find(name: regexp, {transform: null, fields: {_id: 1, name: 1, logo: 1}})
    foundFetched = found.fetch()
    for p in packages
      for found in foundFetched
        if p.name.toLowerCase() == found.name.toLowerCase()
          p._id = found._id
          p.name = found.name
          p.logo = found.logo
    packages

  getPackages: (repoUrl) ->
    byFile = getUsedPackages(repoUrl)
    packages = []
    for file in byFile
      for packageName in file.packages
        p =
          name: packageName
          packager: file.packager
          evidence:
            github:
              path: file.path
              url: file.url
        packages.push(p)
      p =
        name: file.packager
        evidence:
          github:
            path: file.path
            url: file.url
      packages.push(p)

    _.uniq(packages, (p) -> p.name)

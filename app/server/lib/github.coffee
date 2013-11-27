GithubApi = Meteor.require('github')
@github = new GithubApi(
  version: "3.0.0"
  debug: true
  protocol: "https")

knownPackagers =
  'package.json': 'npm'
  'packages': 'meteor'
  'packages.json': 'meteor-npm'
  'smart.json': 'meteor-meteorite'
  'requirements.txt': 'python'
  'Gemfile': 'ruby'
  'pom.xml': 'java'

@getPackages = (user, repo, sha) ->
  files = listFiles(user, repo, sha)
  files = files.filter (f) ->
    name = f.substr(f.lastIndexOf('/') + 1)
    knownPackagers[name]

  files = files.map (f) ->
    name = f.substr(f.lastIndexOf('/') + 1)
    {
      path: f
      name: name
      packager: knownPackagers[name]
    }
  files

listFiles = (user, repo, sha) ->
  sha = 'HEAD' unless sha
  res = getTree(user: user, repo: repo, sha: sha, recursive: 1)
  _.pluck(res.tree, 'path')

getTree = Async.wrap(github.gitdata.getTree)
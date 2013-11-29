GithubApi = Meteor.require('github')
Future = Npm.require('fibers/future')

githubapi = new GithubApi(
  version: "3.0.0"
  debug: true
  protocol: "https")

log = new Logger('github')

@github =
  getPackageFiles: (knownPackagers, user, repo) ->
    getPackageFiles(knownPackagers, user, repo)

getTree = Async.wrap(githubapi.gitdata.getTree)

listFiles = (user, repo, opt_sha) ->
  sha = 'HEAD' unless opt_sha
  getTree(user: user, repo: repo, sha: sha, recursive: 1).tree

getPackageFiles = (knownPackagers, user, repo) ->
  files = listFiles(user, repo)
  files = _.filter files, (f) ->
    path = f.path
    for packager, pattern of knownPackagers
      if pattern.test(path)
        f.packager = packager
        f.pattern = pattern
        return true
    return false
  fetchFilesContent(files)
  files

fetchFilesContent = (files) ->
  futures = files.map (f) ->
    fetchContent(f)
  Future.wait(futures)

fetchContent = (file) ->
  future = new Future()
  onComplete = future.resolver()
  Meteor.http.get file.url, {headers: "User-Agent": "Meteor/1.0"}, (error, result) ->
    if error
      log.error("Error from github: #{error}")
    else
      if result.statusCode == 200
        if result.data.encoding == 'base64'
          file.content = base64decode(result.data.content)
        else
          log.error("Don't know how to deal with encoding for #{JSON.stringify(result)}")
      else
        log.error("Result code error: #{result}")
    onComplete(error, result)
  future


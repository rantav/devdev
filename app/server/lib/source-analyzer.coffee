knownPackagers =
  # Regexp to match package specifiers
  'npm': /(^|\/)(package\.json)$/
  'meteor': /(^|\/)(\.meteor\/packages)$/
  'meteor-npm': /(^|\/)(packages\.json)$/
  'meteor-meteorite': /(^|\/)(smart\.json)$/
  'python': /(^|\/)(requirements\.txt)$/
  'ruby': /(^|\/)(Gemfile)$/
  'java': /(^|\/)(pom\.xml)$/

repoHanlers =
  'github': Url.githubRegEx

log = new Logger('source-analyzer')

@analyzer =
  getUsedTools: (repoUrl) ->
    repoHandler = resolveRepoHandler(repoUrl)
    if repoHandler and repoHandler.type == 'github'
      files = github.getPackageFiles(knownPackagers, repoHandler.user, repoHandler.repo)
    if files
      for f in files
        addUsedToolsInFile(f)
    files

resolveRepoHandler = (repoUrl) ->
  if repoUrl
    for name, pattern of repoHanlers
      if match = repoUrl.match(pattern)
        return {
          type: name
          user: match[1]
          repo: match[2]}

addUsedToolsInFile = (file) ->
  content = file.content
  packager = resolvePackager(file.packager)
  if packager
    file.tools = packager.getTools(content)
  else
    log.error("Cannot resolve packager for file #{JSON.stringify(file)}")

resolvePackager = (packagerName) ->
  packagerImplementations[packagerName]

meteorPackager =
  getTools: (fileContent) ->
    if fileContent
      return fileContent.split('\n').filter((line) -> line.indexOf('#') != 0 and line.trim().length > 0)

npmPackager =
  getTools: (fileContent) ->
    if fileContent
      json = JSON.parse(fileContent)
      return _.keys(json)

meteoritePackager =
  getTools: (fileContent) ->
    if fileContent
      json = JSON.parse(fileContent)
      return _.keys(json.packages)

packagerImplementations =
  'meteor': meteorPackager
  'meteor-npm': npmPackager
  'npm': npmPackager
  'meteor-meteorite': meteoritePackager
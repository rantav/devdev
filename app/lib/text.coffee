# Text handling utils

root = exports ? this

root.Text = {}

capturePatterns = [
  [/(\s+)(\/technology\/[^\s]+)/g,    '$1[$2]($2)'],
  [/^(\/technology\/[^\s]+)/g,      '[$1]($1)']
]
# Same as markdown, but looks for "smart links and makes them actual links".
# for example /technology/javascript becomes [/technology/javascript](/technology/javascript)
# which is easily translated by marked to html links
Text.markdownWithSmartLinks = (markdown) ->
  Text.replaceByPatterns(markdown, capturePatterns)


escapePatterns = [
  [/^#/g,    '\\#']
]
Text.escapeMarkdown = (markdown) ->
  Text.replaceByPatterns(markdown, escapePatterns)

Text.replaceByPatterns = (markdown, patterns) ->
  for pattern in patterns
    markdown = markdown.replace(pattern[0], pattern[1])
  markdown

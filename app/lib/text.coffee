# Text handling utils

root = exports ? this

root.Text = {}

capturePatterns = [
  [/(\s+)(\/tool\/[^\s]+)/g,    '$1[$2]($2)'],
  [/^(\/tool\/[^\s]+)/g,      '[$1]($1)']
]
# Same as markdown, but looks for "smart links and makes them actual links".
# for example /tool/javascript becomes [/tool/javascript](/tool/javascript)
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

Text.tokenize = (str) ->
  str.split(/[^\w]/)
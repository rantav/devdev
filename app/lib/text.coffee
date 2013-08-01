# Text handling utils

root = exports ? this

root.Text = {}

capturePatterns = [/( \/technology\/[^\s]+)/g, /^(\/technology\/[^\s]+)/g]
# Same as markdown, but looks for "smart links and makes them actual links".
# for example /technology/javascript becomes [/technology/javascript](/technology/javascript)
# which is easily translated by marked to html links
Text.markdownWithSmartLinks = (markdown) ->
  for pattern in capturePatterns
    markdown = markdown.replace(pattern, '[$1]($1)')
  markdown
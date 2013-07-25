# Text handling utils

root = exports ? this

root.Text = {}

# Same as markdown, but looks for "smart links and makes them actual links".
# for example /technology/javascript becomes [/technology/javascript](/technology/javascript)
# which is easily translated by marked to html links
Text.markdownWithSmartLinks = (markdown) ->
  markdown = markdown.replace(/(\/technology\/[^ ]+)/g, '[$1]($1)')

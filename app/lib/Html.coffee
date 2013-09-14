root = exports ? this

root.Html = {}

Html.imgPolaroid = (url) ->
  if not url then return ''
  "<img src='#{url}' class='img-polaroid'></img>"

Html.pleasLoginAlertifyHtml = ->
  closeJs = '$("#alertify-ok").trigger("click")'
  googleJs = "javascript:(function(){Meteor.loginWithGoogle();#{closeJs}})()"
  googleBtn = "<a href='#{googleJs}' class='btn'><i class='icon-google-plus-sign'></i> With Google</a>"
  githubJs = "javascript:(function(){Meteor.loginWithGithub();#{closeJs}})()"
  githubBtn = "<a href='#{githubJs}' class='btn'><i class='icon-github-sign'></i> With GitHub</a>"
  "<i class='icon-user icon-4x'> </i> <h2>Please log in</h2> #{googleBtn} or #{githubBtn}"
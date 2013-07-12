window.User = {}
User.getUserPictureHtml = (user) ->
  if user and user.services and user.services.google
    picture = user.services.google.picture
    if picture
      html = "<img src='#{picture}' class='img-polaroid'/>"
  if not picture
    html = '<i class="icon-user icon-3x img-polaroid">&nbsp</i>'
  html
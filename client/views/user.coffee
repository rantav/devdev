window.User = {}
User.getUserPictureHtml = (user) ->
  picture = user.services.google.picture
  if picture then "<img src='#{picture}' class='img-polaroid'/>" else '<i class="icon-user icon-3x img-polaroid">&nbsp</i>'
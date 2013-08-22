window.ImageHandler = class ImageHandler
  type: ->
    'image'

  renderAdder: (aspect, jqPath) ->
    html =
      "<div class='image-aspect edit-section'>
        <div class='span5'>
          <form class='contribute-form'>
           <div class='control-group'>
            <input class='filepicker-dragdrop'
                   type='filepicker-dragdrop'
                   data-fp-mimetypes='image/*'
                   data-fp-container='modal'
                   data-fp-button-class='btn'
                   data-fp-multiple='false'
                   data-fp-services='COMPUTER,IMAGE_SEARCH,URL'></input>
            <input type='hidden' id='new-aspect-value'/>
           </div>
           <div class='controls' style='display:none'>
             <button type='submit' class='btn btn-primary submit-contribution' data-referred-id='#{aspect.id()}-value'>Save</button>
             <button type='button' class='btn cancel-contribution' data-referred-id='#{aspect.id()}-value'>Cancel</button>
           </div>
          </form>
         </div>
         <div class='span5'>
           <div class='contribute-preview img-logo-aspect' style='border-left-color: #{Meteor.user().profile.color}'/>
         </div>
       </div>"

    if not jqPath then return html

    $(jqPath).html(html)
    element = $(jqPath).find('.filepicker-dragdrop')[0]
    element.onchange = (event) =>
      @onPickFile(event)
    filepicker.constructWidget(element);

  onPickFile: (event) ->
    fpfile = event.fpfile
    $target = $(event.target)
    html = "<img src='#{fpfile.url}' class='img-polaroid'></img>"
    $target.parents('.edit-section').find('.contribute-preview').html(html)
    $target.parents('.edit-section').find('.controls').show(200)
    $target.parents('.edit-section').find('input[type=hidden]').val(fpfile.url)

  handleNewAspect: (aspect, event) ->
    $name = $('#new-aspect-name')
    name = $name.val()
    if not name
      $name.parents('.control-group').addClass('error')
      $name.focus()
      return
    $value = $('#new-aspect-value')
    value = $value.val()
    if not value
      alertify.error('Please senect an image')
      return

    analytics.track('add new aspect', {name: name})
    NProgress.start()
    Meteor.call 'contributeNewAspect', technology.id(), name, value, (err, ret) ->
      if err
        alertify.error err
        NProgress.done()
      else
        $name.val('')
        $value.val('')
        NProgress.done()

  init: (template) ->
    handleNewAspect = @handleNewAspect
    handleAspectContribution = @handleAspectContribution
    template.events
      'click .image-aspect .cancel-contribution': (event) ->
        console.log(event)
        $target = $(event.target)
        $target.parent().hide(200)
        $target.parents('.edit-section').find('textarea.contribute-text').val('')
        $target.parents('.edit-section').find('.contribute-preview').html('')

      'submit .image-aspect form.contribute-form': (event) ->
        if @id() == 'new-aspect'
          handleNewAspect(this, event)
        else
          handleAspectContribution(this, event)
        # return false to prevent browser form submission
        false

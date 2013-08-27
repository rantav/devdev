window.TagsHandler = class TagsHandler
  type: ->
    'tags'

  view: (aspectContribution) ->
    url = aspectContribution.content()
    url = aspectContribution.imageUrl({h: 30})
    cdned = Cdn.cdnify(url)
    "<div class='tags-aspect'>
      TODO: TAGS...
     </div>"

  renderAdder: (aspect, jqPath) ->
    html =
      "<div class='tags-aspect edit-section'>
        <div class='span5'>
          <form class='contribute-form'>
           <div class='control-group'>
            <input value='bla,bla, blah' data-role='tagsinput' class='tagsinput'></input>
           </div>
           <div class='controls' style='display:none'>
             <button type='submit' class='btn btn-primary submit-contribution' data-referred-id='#{aspect.id()}-value'>Save</button>
             <button type='button' class='btn cancel-contribution' data-referred-id='#{aspect.id()}-value'>Cancel</button>
           </div>
          </form>
         </div>
       </div>"

    if not jqPath then return ''

    $(jqPath).html(html)
    $(jqPath).find('.tagsinput').tagsinput({
      typeahead: {
        local: ['Amsterdam', 'Washington', 'Sydney', 'Beijing', 'Cairo']
      }
    })

  onPickFile: (event) ->
    fpfile = event.fpfile
    $target = $(event.target)
    url = fpfile.url
    resized = url + "/convert?h=30"
    html = "<img src='#{resized}' class='img-polaroid'></img>"
    $target.parents('.edit-section').find('.contribute-preview').html(html)
    $target.parents('.edit-section').find('.controls').show(200)
    $target.parents('.edit-section').find('input[type=hidden]').val(url)

  handleNewAspect: (aspect, event) =>
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
    Meteor.call 'contributeNewAspect', technology.id(), name, value, @type(), (err, ret) ->
      if err
        alertify.error err
        NProgress.done()
      else
        $name.val('')
        $value.val('')
        window._newAspect.setType(undefined)
        window._newAspect.setName(undefined)
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

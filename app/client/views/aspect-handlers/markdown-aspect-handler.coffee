window.MarkdownHandler = class MarkdownHandler
  type: ->
    'markdown'

  view: (aspectContribution) ->
    "<div class='markdown-aspect'>
      #{marked(aspectContribution.markdownProcessed())}
     </div>"

  renderAdder: (aspect, jqPath) ->
    html =
      "<div class='markdown-aspect edit-section'>
        <div class='span5'>
          <form class='contribute-form'>
           <div class='control-group'>
             <textarea class='contribute-text' id='#{aspect.id()}-value' placeholder='#{aspect.placeholderText()}'/>
           </div>
           <div class='controls' style='display:none'>
             <small class='muted pull-right'>Markdown enabled</small>
             <button type='submit' class='btn btn-primary submit-contribution' data-referred-id='#{aspect.id()}-value'>Save</button>
             <button type='button' class='btn cancel-contribution' data-referred-id='#{aspect.id()}-value'>Cancel</button>
           </div>
          </form>
         </div>
         <div class='span5'>
           <p class='contribute-preview' style='border-left-color: #{Meteor.user().profile.color}'/>
         </div>
       </div>"
    if jqPath
      $(jqPath).html(html)
      contributeText = $(jqPath).find('textarea.contribute-text')
      contributeText.autogrow()
    else
      return html



  handleAspectContribution: (aspect, event) ->
    analytics.track('Submit aspect contribution')
    text = $('textarea.contribute-text', event.target).val()
    if text
      Meteor.call 'contributeToAspect', technology.id(), aspect.id(), text, (err, ret) ->
        if err
          alertify.error err
        else
          $target = $(event.target)
          $target.find('textarea.contribute-text').val('')

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
      $value.parents('.control-group').addClass('error')
      $value.focus()
      return

    analytics.track('add new aspect', {name: name})
    Meteor.call 'contributeNewAspect', technology.id(), name, value, (err, ret) ->
      if err
        alertify.error err
      else
        $name.val('')
        $value.val('')


  init: (template) ->
    handleNewAspect = @handleNewAspect
    handleAspectContribution = @handleAspectContribution
    contributeText = $('textarea.contribute-text')
    if Meteor.userId()
      contributeText.autogrow()

    template.events
      'click .markdown-aspect.cancel-contribution': (event)->
        analytics.track('Cancel aspect contribution')
        $target = $(event.target)
        $target.parent().hide(200)
        $target.parents('.edit-section').find('textarea.contribute-text').val('')
        $target.parents('.edit-section').find('.contribute-preview').html('')
        $target.parents('.edit-section').find('.control-group').removeClass('error')

      'submit .markdown-aspect form.contribute-form': (event) ->
        if @id() == 'new-aspect'
          handleNewAspect(this, event)
        else
          handleAspectContribution(this, event)
        # return false to prevent browser form submission
        false

      'keyup .markdown-aspect textarea.contribute-text': (event) ->
        $target = $(event.target)
        text = $target.val()
        text = Text.markdownWithSmartLinks(text)
        text = Text.escapeMarkdown(text)
        html = marked(text)
        $target.parents('.edit-section').find('.contribute-preview').html(html)
        if text
          $target.parents('.control-group').removeClass('error')
        else
          $target.parents('.control-group').addClass('error')


      'blur .markdown-aspect textarea.contribute-text': (event) ->
        $relatedTarget = $(event.relatedTarget)
        if $relatedTarget.data('referred-id') == event.target.id
          # Don't hide the controls if they have the focus
          return
        $target = $(event.target)
        $target.parents('.edit-section').find('.controls').hide(200)
        $target.parents('.edit-section').find('.control-group').removeClass('error')

      'blur .markdown-aspect .controls button': (event) ->
        $target = $(event.target)
        if event.relatedTarget
          $relatedTarget = $(event.relatedTarget)
          if $relatedTarget.data('referred-id') == $target.data('referred-id') or event.relatedTarget.id == $target.data('referred-id')
            # Don't hide the controls if they have the focus
            return
        $target.parent().hide(200)
        $target.parents('.edit-section').find('.control-group').removeClass('error')

      'focus .markdown-aspect textarea.contribute-text': (event) ->
        $target = $(event.target)
        $target.parents('.edit-section').find('.controls').show(200)


window.MarkdownHandler = class MarkdownHandler
  view: (aspectContribution) ->
    marked(aspectContribution.markdownProcessed())

  renderAdder: (aspect) ->
      "<form class='contribute-form edit-section'>
         <div class='span5'>
           <div class='control-group'>
             <textarea class='contribute-text' id='#{aspect.id()}-value' placeholder='#{aspect.placeholderText()}'/>
           </div>
           <div class='controls' style='display:none'>
             <small class='muted pull-right'>Markdown enabled</small>
             <button type='submit' class='btn btn-primary submit-contribution' data-referred-id='#{aspect.id()}-value'>Save</button>
             <button type='button' class='btn cancel-contribution' data-referred-id='#{aspect.id()}-value'>Cancel</button>
           </div>
         </div>
         <div class='span5'>
           <p class='contribute-preview' style='border-left-color: #{Meteor.user().profile.color}'/>
         </div>
       </form>"

  init: (template) ->
    template.events
      'click .cancel-contribution': (event)->
        analytics.track('Cancel aspect contribution')
        $target = $(event.target)
        $target.parent().hide(200)
        $target.parents('.edit-section').find('textarea.contribute-text').val('')
        $target.parents('.edit-section').find('p.contribute-preview').html('')
        $target.parents('.edit-section').find('.control-group').removeClass('error')

      'submit form.contribute-form': (event) ->
        analytics.track('Submit aspect contribution')
        text = $('textarea.contribute-text', event.target).val()
        if text
          Meteor.call 'contributeToAspect', technology.id(), @id(), text, (err, ret) ->
            if err
              alertify.error err
            else
              $target = $(event.target)
              $target.find('textarea.contribute-text').val('')

        # return false to prevent browser form submission
        false

      'keyup textarea.contribute-text': (event) ->
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


      'blur textarea.contribute-text': (event) ->
        $relatedTarget = $(event.relatedTarget)
        if $relatedTarget.data('referred-id') == event.target.id
          # Don't hide the controls if they have the focus
          return
        $target = $(event.target)
        $target.parents('.edit-section').find('.controls').hide(200)
        $target.parents('.edit-section').find('.control-group').removeClass('error')

      'blur .controls button': (event) ->
        $target = $(event.target)
        if event.relatedTarget
          $relatedTarget = $(event.relatedTarget)
          if $relatedTarget.data('referred-id') == $target.data('referred-id') or event.relatedTarget.id == $target.data('referred-id')
            # Don't hide the controls if they have the focus
            return
        $target.parent().hide(200)
        $target.parents('.edit-section').find('.control-group').removeClass('error')

      'focus textarea.contribute-text': (event) ->
        $target = $(event.target)
        $target.parents('.edit-section').find('.controls').show(200)


window.TagsHandler = class TagsHandler
  type: ->
    'tags'

  view: (aspectContribution, jqPath, readonly) ->
    tags = aspectContribution.content() || ''
    if aspectContribution.contributorId() == Meteor.userId() and not readonly
      return @renderEditor(aspectContribution.aspect(), jqPath, tags)
    else
      return @renderView(aspectContribution)

  renderView: (aspectContribution) ->
    tags = aspectContribution.getTags()
    prefix = aspectContribution.aspect().defId() # vertical / stack
    html = ["<div class='tags-aspect'>"]
    for t in tags
      link = "#{prefix}:#{t}"
      html.push "<a href='#{Url.tagLink(link)}' class='label label-info'>#{t}</a>"
    html.push "</div>"
    html.join('')

  renderEditor: (aspect, jqPath, tagString) ->
    if aspect.defId()
      def = Technology.aspectDefinitions()[aspect.defId()]
      datasource = def.datasource
    html = @editHtml(tagString)

    $(jqPath).html(html)
    jqBind = ->
      # BUG: When sepecting Vertical, then selecting Stack, the suggstion list doen't
      # get updated. The typeahead value isn't correct...
      $(jqPath).find('.tagsinput').tagsinput({
        typeahead: {
          local: aspect.technology()[datasource](),
          freeInput: true
        }
      })
    Meteor.setTimeout(jqBind, 100)
    return html

  renderAdder: (aspect, jqPath) ->
    if aspect.hasContributionsFromUser(Meteor.userId())
      return ''
    @renderEditor(aspect, jqPath, '')

  handleAspectContribution: (aspect, tags) ->
    analytics.track('Submit aspect contribution')
    text = tags.join(',')
    if text
      NProgress.start()
      Meteor.call 'contributeToAspect', technology.id(), aspect.id(), text, (err, ret) ->
        if err
          alertify.error err
        else
          NProgress.done()

  handleNewAspect: (aspect, tags) =>
    $name = $('#new-aspect-name')
    name = $name.val()
    if not name
      $name.parents('.control-group').addClass('error')
      $name.focus()
      return
    text = tags.join(',')
    if not text then return
    def = window._newAspect.defId()
    analytics.track('add new aspect', {name: name})
    NProgress.start()
    Meteor.call 'contributeNewAspect', technology.id(), name, text, def, (err, ret) ->
      if err
        alertify.error err
        NProgress.done()
      else
        $name.val('')
        window._newAspect.setType(undefined)
        window._newAspect.setName(undefined)
        window._newAspect.setDefId(undefined)
        NProgress.done()


  init: (template) ->
    handleNewAspect = @handleNewAspect
    handleAspectContribution = @handleAspectContribution
    template.events
      'blur .tags-aspect input': (event) ->
        $target = $(event.target)
        $target.parents('.edit-section').find('.controls').hide(200)

      'submit .tags-aspect form.contribute-form': (event) ->
        text = $(event.target).find('input.tt-query').val()
        text = (t.trim() for t in text.split(','))
        tags = $(event.target).find(".tagsinput").tagsinput('items')
        tags = _.union(tags, text)
        if @id() == 'new-aspect'
          handleNewAspect(this, tags)
        else
          aspect = if this instanceof AspectContribution then this.aspect() else this
          handleAspectContribution(aspect, tags)
        # return false to prevent browser form submission
        false

      'focus .tags-aspect input': (event) ->
        $target = $(event.target)
        $target.parents('.edit-section').find('.controls').show(200)

  editHtml: (tagString) ->
    "<div class='tags-aspect edit-section'>
      <div class='span5'>
        <form class='contribute-form'>
         <div class='control-group'>
          <input value='#{tagString}' data-role='tagsinput' class='tagsinput'></input>
         </div>
         <div class='controls' style='display:none'>
           <small class='muted pull-right'>Enter tags</small>
           <button type='submit' class='btn btn-primary submit-contribution'>Save</button>
           <button type='button' class='btn cancel-contribution'>Cancel</button>
         </div>
        </form>
       </div>
     </div>"


describe 'Template.technologies', ->
  describe '.technologies', ->
    beforeEach ->
      Technologies.find = (filter, options) ->
        if options.sort.updatedAt == -1
            {fetch: -> [{_id: '1'}, {_id: '2'}]}
    it 'Should return all technologies' , ->
      expect(Template.technologies.technologies().length).toBe(2)
    it 'Should return the technologies sorted by last update (reverse)', ->
      expect(Template.technologies.technologies()[0].id()).toBe('1')

describe 'Template.contributors', ->
  describe '.contributors', ->
    beforeEach ->
      Contributors.find = sinon.stub()
      Contributors.find.withArgs({},
        {sort: {'profile.contributionCount': -1}}).returns
          fetch: ->
            [{_id: '1'}, {_id: '2'}]
    it 'Should return all contributors' , ->
      expect(Template.contributors.contributors().length).toBe(2)
    it 'Should return the contributors sorted by number of contributions', ->
      expect(Template.contributors.contributors()[0].id()).toBe('1')

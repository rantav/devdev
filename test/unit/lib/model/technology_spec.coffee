describe 'Technology', ->
  describe '@all', ->
    describe 'when there are no technologies', ->
      beforeEach -> Technologies.find = -> {fetch: -> []}
      it 'should return an empty array', ->
        expect(Technology.all()).toEqual([])
    describe 'when there is one technology', ->
      beforeEach -> Technologies.find = -> {fetch: -> [{_id: '1'}]}
      it 'should return one Technology', ->
        expect(Technology.all().length).toEqual(1)
      it 'should return a technology with the ID 1', ->
        expect(Technology.all()[0].id()).toEqual('1')
    describe 'when there are two technologies but one is deleted', ->
      beforeEach -> Technologies.find = (selector, options)->
        if selector.deletedAt['$exists'] == false
          return {fetch: -> [{_id: '1'}]}
      it 'should return one Technology', ->
        expect(Technology.all().length).toEqual(1)
      it 'should return a technology with the ID 1', ->
        expect(Technology.all()[0].id()).toEqual('1')

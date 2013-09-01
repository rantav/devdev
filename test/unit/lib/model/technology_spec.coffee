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
  describe '@createPinnedAspects', ->
    pinned = null
    beforeEach ->
      Meteor.uuid = -> 'uuid'
      pinned = Technology.createPinnedAspects()
    it 'should return 2 pinned aspect definitions', ->
      expect(pinned.length).toEqual(2)
  describe '@pinnedAspectDefIds', ->
    it 'should return the pinned aspect definitions', ->
      expect(Technology.pinnedAspectDefIds()).toEqual(['vertical', 'stack'])
  describe '@create', ->
    t = null
    tdata = null
    now = null
    beforeEach ->
      now = new Date()
      Meteor.userId = -> '1'
      Meteor.uuid = -> 'uuid'
      sinon.stub(Technologies, 'insert', (data) ->
        tdata = data
        tdata.id = 'tid')
      sinon.stub(Technologies, 'findOne', (id) ->
        if id == tdata.id then return tdata)
      t = Technology.create('name')
    afterEach ->
      Technologies.insert.restore()
      Technologies.findOne.restore()
    it 'should create a new technology', ->
      expect(t).toBeDefined()
    it 'should create a new technology with the given name', ->
      expect(t.name()).toBe('name')
    it 'the creator of the technology should be the current user', ->
      expect(t.creator().id()).toBe('1')
    it 'should have pinned aspects', ->
      expect(t.aspects().length).toBe(2)
    it 'should be created just now', ->
      expect(t.createdAt()).not.toBeLessThan(now)
    it 'should be updated just now', ->
      expect(t.updatedAt()).not.toBeLessThan(now)

describe 'Contributor', ->
  describe 'all', ->
    describe 'when there are no users', ->
      beforeEach -> Meteor.users.find = -> {fetch: -> []}
      it 'should return an empty array', ->
        expect(Contributor.all()).toEqual([])
    describe 'when there is one user', ->
      beforeEach -> Meteor.users.find = -> {fetch: -> [{_id: '1'}]}
      it 'should return one Contributor', ->
        expect(Contributor.all().length).toEqual(1)
      it 'should return a contributor with the ID 1', ->
        expect(Contributor.all()[0].id()).toEqual('1')
  describe 'find', ->
    beforeEach -> Meteor.users.findOne = (idOrName) ->
      if idOrName == '1' or idOrName['profile.name'] and idOrName['profile.name'].source == '^one$'
        return {_id: '1', profile: {name: 'one'}}
    describe 'by id', ->
      it 'should return the user with id 1', ->
        expect(Contributor.findOne('1').id()).toEqual('1')
    describe 'by name', ->
      it 'should return the user with id 1, name one', ->
        expect(Contributor.findOne('one').name()).toEqual('one')
    describe 'by nonexisting id', ->
      it 'should return the user "unknown"', ->
        expect(Contributor.findOne('2').id()).toEqual('unknown')
        expect(Contributor.findOne('2').name()).toEqual('unknown')
  describe 'countContributions', ->
    it 'should count 0 when the user has none', ->
      c = new Contributor({profile: {contributions: []}})
      expect(c.countContributions()).toEqual(0)
    it 'should count 1 when the user has one', ->
      c = new Contributor({profile: {contributions: [{}]}})
      expect(c.countContributions()).toEqual(1)
    it 'should count 1 when the user has one deleted and one not deleted', ->
      c = new Contributor({profile: {contributions: [{}, {deletedAt: new Date()}]}})
      expect(c.countContributions()).toEqual(1)
  describe 'photoHtml', ->
    describe 'for google user', ->
      it 'should display the picture when the user has one', ->
        c = new Contributor({services: {google: {picture: 'hello'}}})
        expect(c.photoHtml()).toEqual("<img src='hello' class='img-polaroid'/>")
      it 'should display a generic picture when the user doesnt have a picture', ->
        c = new Contributor({services: {google: {}}})
        expect(c.photoHtml()).toEqual("<img src='/img/user.png' class='img-polaroid'/>")
    describe 'for github user', ->
      it 'should display the picture when the user has one', ->
        c = new Contributor({services: {github: {picture: 'hello'}}})
        expect(c.photoHtml()).toEqual("<img src='hello' class='img-polaroid'/>")

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
        expect(Contributor.find('1').id()).toEqual('1')
    describe 'by name', ->
      it 'should return the user with id 1, name one', ->
        expect(Contributor.find('one').name()).toEqual('one')
    describe 'by nonexisting id', ->
      it 'should return the user "unknown"', ->
        expect(Contributor.find('2').id()).toEqual('unknown')
        expect(Contributor.find('2').name()).toEqual('unknown')

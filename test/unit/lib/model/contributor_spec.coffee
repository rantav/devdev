describe 'Contributor', ->
  describe 'all', ->
    describe 'when there are no users', ->
      beforeEach -> Meteor.users.find = -> {fetch: -> []}
      it 'should return an empty array', ->
        expect(Contributor.all()).toEqual([])
    describe 'when there is one user', ->
      beforeEach -> Meteor.users.find = -> return {fetch: -> [{_id: 'one'}]}
      it 'should return one Contributor', ->
        expect(Contributor.all().length).toEqual(1)
      it 'should return a contributor with the ID one', ->
        expect(Contributor.all()[0].id()).toEqual('one')

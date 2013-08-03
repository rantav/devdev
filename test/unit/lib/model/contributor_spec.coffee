describe 'Contributor', ->
  describe '@all', ->
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
  describe '@findOne', ->
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
  describe 'contributionCount', ->
    it 'should count 0 when the user has none', ->
      c = new Contributor({profile: {contributions: []}})
      expect(c.contributionCount()).toEqual(0)
    it 'should count 1 when the user has one', ->
      c = new Contributor({profile: {contributionCount: 1}})
      expect(c.contributionCount()).toEqual(1)
    it 'should count 1 when starting from 0 and then adding one technologyContribution', ->
      c = new Contributor()
      c.addTechnologyContribution(new Technology())
      expect(c.contributionCount()).toEqual(1)
    it 'should count 1 when starting from 0 and then adding one aspectContribution', ->
      c = new Contributor()
      t = new Technology({aspects: [{_id: '1'}]})
      a = t.aspects()[0]
      c.addAspectContribution(new AspectContribution({}, a))
      expect(c.contributionCount()).toEqual(1)
    it 'should count 0 when starting from 0 and then adding two contributions of each type and then deleting them', ->
      c = new Contributor()
      t = new Technology({aspects: [{_id: '1'}]})
      a = t.aspects()[0]
      c.addTechnologyContribution(new Technology())
      ac = new AspectContribution({}, a)
      c.addAspectContribution(ac)
      c.deleteAspectContribution(ac)
      c.deleteTechnologyContribution(c)
      expect(c.contributionCount()).toEqual(0)


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

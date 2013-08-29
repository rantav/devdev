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
  describe 'addTechnologyContribution', ->
    describe 'adding the technology contribution to the contributor', ->
      c = null
      t = null
      beforeEach ->
        c = new Contributor({_id: '2'})
        createdAt = new Date(0)
        updatedAt = new Date(200000)
        t = new Technology({_id: '1', createdAt: createdAt, updatedAt: updatedAt})
        expect(c.contributionCount()).toEqual(0)
        expect(c.contributions()).toEqual([])
        c.addTechnologyContribution(t)
        sinon.stub(Technology, 'findOne', (technologyId) -> if technologyId == '1' then t)
      afterEach ->
        Technology.findOne.restore()
      it 'should count exactly 1 contribution', ->
        expect(c.contributionCount()).toEqual(1)
      it 'should have the exact same contribution that we added', ->
        contribs = c.contributions()
        expect(contribs.length).toEqual(1)
        contrib = contribs[0]
        expect(contrib.type()).toEqual('technology')
        expect(contrib.technology()).toEqual(t)
  describe 'findUserTechnologyContributions', ->
    it 'should not find a contribution that doesn\'t exist', ->
      c = new Contributor()
      t = new Technology()
      expect(c.findUserTechnologyContributions(t)).toEqual([])
    it 'should find a contribution after it\'s been added', ->
      c = new Contributor()
      createdAt = new Date(0)
      updatedAt = new Date(200000)
      t = new Technology({_id: '1', createdAt: createdAt, updatedAt: updatedAt})
      c.addTechnologyContribution(t)
      expect(c.findUserTechnologyContributions(t)).toEqual([{
        technologyId: '1', type: 'technology', createdAt: createdAt,
        updatedAt: updatedAt}])
  describe 'photoUrl', ->
    describe 'for google user', ->
      describe 'when a user has a photo', ->
        c = null
        beforeEach ->
          c = new Contributor({services: {google: {picture: 'hello'}}})
        it 'should display the picture', ->
          expect(c.photoUrl()).toEqual("hello")
        it 'should display a resized picture when asked for', ->
          expect(c.photoUrl(40)).toEqual("hello?sz=40")
      describe 'when a user does not have a picture', ->
        c = null
        beforeEach ->
          c = new Contributor({services: {google: {}}})
        it 'should display a generic picture', ->
          expect(c.photoUrl()).toEqual("http://d16azfexq1dof6.cloudfront.net/img/user.png")
        it 'should display a generic picture, resized, when asked for', ->
          expect(c.photoUrl(40)).toEqual("http://d16azfexq1dof6.cloudfront.net/img/user-40x40.png")
    describe 'for github user', ->
      it 'should display the picture when the user has one', ->
        c = new Contributor({services: {github: {picture: 'hello'}}})
        expect(c.photoUrl()).toEqual("hello")

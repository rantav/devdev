Meteor.subscribe 'technologies',
  onReady: -> logger.log('technologies ready')
  onError: -> logger.error('technologies error')

Meteor.subscribe 'users',
  onReady: -> logger.log('users ready')
  onError: -> logger.error('users error')

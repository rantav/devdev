Session.set('devdevFullySynched', false)
subscriptions = ['technologies', 'technologies-deleted', 'users']
success = 0
for s in subscriptions
  ((s) ->
    Meteor.subscribe s,
      onReady: ->
        logger.log('OK: ' + s)
        success++
        if success == subscriptions.length
          Session.set('devdevFullySynched', true)
          NProgress.done()

      onError: -> logger.error('ERROR: ' + s)
  )(s)

Session.set('devdevFullySynched', false)
subscriptions = ['technologies', 'technologiesDeleted', 'contributors']
window.subscriptionHandles = {}
success = 0
for s in subscriptions
  ((s) ->
    subscriptionHandles[s] = Meteor.subscribe s,
      onReady: ->
        logger.log('OK: ' + s)
        success++
        if success == subscriptions.length
          Session.set('devdevFullySynched', true)
          NProgress.done()

      onError: -> logger.error('ERROR: ' + s)
  )(s)

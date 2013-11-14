Session.set('devdevFullySynched', false)
subscriptions = ['contributors', 'tools']
window.subscriptionHandles = {}
success = 0
for s in subscriptions
  ((s) ->
    subscriptionHandles[s] = Meteor.subscribe s,
      onReady: ->
        success++
        if success == subscriptions.length
          Session.set('devdevFullySynched', true)
          NProgress.done()

      onError: -> log.error('ERROR: ' + s)
  )(s)

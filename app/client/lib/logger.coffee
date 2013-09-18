window.logger = {
  log: (msg) ->
    if console and console.log
      console.log(msg)
  ,
  warn: (msg) ->
    if console and console.warn
      console.warn(msg)
  ,
  error: (msg) ->
    if console and console.error
      console.error(msg)
}
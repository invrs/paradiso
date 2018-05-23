# Exposes a promise array to append to as your components
# run. Wait for promises to resolve before rendering the
# server side response.
#
# The promise array is accessible via `@server.promises`.
#
# This code waits for the promises array to become
# unchanging for a period greater than 10ms. After that
# period, it waits for all promises to resolve.
#
module.exports = class Waiter
  constructor: ({ @_promises, @ignore_rejections }) ->

  loop: (run_count=0) ->
    length = @_promises.length
    
    @delay(10)
      .then(
        =>
          if run_count > 500
            Promise.all []
          else
            run_count += 1
            Promise.all @_promises
      )
      .then(
        =>
          if length != @_promises.length
            @loop run_count
        =>
          unless @ignore_rejections
            @error = true
            Promise.all []
          else if length != @_promises.length
            @loop run_count
      )

  delay: (timeout) ->
    new Promise (resolve) ->
      setTimeout(
        resolve
        timeout
      )

  @wait: (component) ->
    ring = new Waiter component
    ring.wait()

  wait: ->
    @loop().then(=> this)

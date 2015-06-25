Promise = require "bluebird"

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
  constructor: ({ @_promises }) ->

  loop: (run_count=0) ->
    length = @_promises.length
    
    Promise
      .delay(10)
      .then(
        =>
          return [] if run_count > 500
          run_count += 1

          @_promises
      )
      .all()
      .then(
        =>
          if length != @_promises.length
            @loop run_count
      )

  @wait: (component) ->
    ring = new Waiter component
    ring.wait()

  wait: ->
    @loop().then(
      => @_promises
      => false
    )

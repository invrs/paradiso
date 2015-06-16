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
  constructor: ({ @promises }) ->

  loop: (run_count=0) ->
    length = @promises.length
    
    Promise
      .delay(10)
      .then(
        =>
          return [] if run_count > 500
          run_count += 1

          @promises
      )
      .all()
      .then(
        =>
          added = length != @promises.length
          empty = length == 0

          if added || empty
            @loop run_count
      )

  @wait: (globals) ->
    globals.promises = []
    ring = new Waiter globals
    ring.wait()

  wait: ->
    @loop().then(
      => @promises
      => false
    )

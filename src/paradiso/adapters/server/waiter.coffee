m = require "mithril"

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
  constructor: ({ @_promises, @server }) ->

  loop: (run_count=0, fail_count=0) ->
    length = @_promises.length
    return if fail_count > 5
    
    @delay(10)
      .then(
        =>
          console.log("then")
          if run_count > 500
            console.log "a"
            m.sync []
          else
            console.log "b"
            run_count += 1
            m.sync @_promises
      )
      .then(
        =>
          console.log("then 2")
          if length != @_promises.length
            console.log "c"
            @loop run_count
          else
            @loop run_count, fail_count + 1
        =>
          console.log("catch")
          unless @server?.ignore_rejections
            console.log "d"
            @error = true
            m.sync []
          else if length != @_promises.length
            console.log "e"
            @loop run_count
          else
            @loop run_count, fail_count + 1

      )

  delay: (timeout) ->
    deferred = m.deferred()
    setTimeout(
      -> deferred.resolve()
      timeout
    )
    deferred.promise

  @wait: (component) ->
    ring = new Waiter component
    ring.wait()

  wait: ->
    @loop().then(=> this)

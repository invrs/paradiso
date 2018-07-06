Waiter = require "../../lib/paradiso/adapters/server/waiter"
m = require "mithril"

describe "Waiter", ->
  describe "wait", ->
    it "waits for promises", (done) ->
      deferred = m.deferred()
      deferred2 = m.deferred()

      called = false
      called2 = false

      component = _promises: [ deferred.promise ]
      
      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe undefined
        expect(called).toBe true
        expect(called2).toBe true
        done()

      setTimeout(
        =>
          component._promises.push(deferred2.promise)
          called = true
          deferred.resolve()
          setTimeout(
            =>
              called2 = true
              deferred2.resolve()
            30
          )
        10
      )

    it "sets error flag", (done) ->
      deferred = m.deferred()
      deferred2 = m.deferred()

      called = false
      called2 = false

      component = _promises: [ deferred.promise ]

      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe true
        expect(called).toBe true
        expect(called2).toBe false
        done()

      setTimeout(
        =>
          component._promises.push(deferred2.promise)
          called = true
          deferred.reject()
          setTimeout(
            =>
              called2 = true
              deferred2.resolve()
            30
          )
        10
      )

    it "ignores errors", (done) ->
      deferred = m.deferred()
      deferred2 = m.deferred()
      
      called = false
      called2 = false

      component =
        _promises: [ deferred.promise ]
        server: ignore_rejections: true

      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe undefined
        expect(called).toBe true
        expect(called2).toBe true
        done()

      setTimeout(
        =>
          component._promises.push(deferred2.promise)
          called = true
          deferred.reject()
          setTimeout(
            =>
              called2 = true
              deferred2.resolve()
            30
          )
        10
      )

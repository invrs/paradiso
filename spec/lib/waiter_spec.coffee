Waiter = require "../../lib/paradiso/adapters/server/waiter"
m = require "mithril"

describe "Waiter", ->
  describe "wait", ->
    it "waits for promises", (done) ->
      deferred = m.deferred()
      called = false

      setTimeout(
        =>
          called = true
          deferred.resolve()
        10
      )

      component = _promises: [ deferred.promise ]
      
      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe undefined
        expect(called).toBe true
        done()

    it "sets error flag", (done) ->
      deferred = m.deferred()
      deferred2 = m.deferred()
      
      called = false
      called2 = false

      setTimeout(
        =>
          called = true
          deferred.reject()
        10
      )

      setTimeout(
        =>
          called2 = true
          deferred2.resolve()
        10
      )

      component = _promises: [
        deferred.promise,
        deferred2.promise
      ]
      
      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe true
        expect(called).toBe true
        expect(called2).toBe true
        done()

    it "ignores errors", (done) ->
      deferred = m.deferred()
      deferred2 = m.deferred()
      
      called = false
      called2 = false

      setTimeout(
        =>
          called = true
          deferred.reject()
        10
      )

      setTimeout(
        =>
          called2 = true
          deferred2.resolve()
        10
      )

      component = _promises: [
        deferred.promise,
        deferred2.promise
      ]

      component =
        _promises: [ deferred.promise ]
        ignore_rejections: true
      
      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe undefined
        expect(called).toBe true
        expect(called2).toBe true
        done()

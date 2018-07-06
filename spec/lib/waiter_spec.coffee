Waiter = require "../../lib/paradiso/adapters/server/waiter"

describe "Waiter", ->
  describe "wait", ->
    it "waits for promises", (done) ->
      promise = -> new Promise (resolve) -> resolve()
      promise2 = -> new Promise (resolve) -> resolve()

      called = false
      called2 = false

      component = _promises: [ promise ]
      
      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe undefined
        expect(called).toBe true
        expect(called2).toBe true
        done()

      setTimeout(
        =>
          component._promises.push promise2
          called = true
          component._promises[0]()
          setTimeout(
            =>
              called2 = true
              component._promises[1]()
            30
          )
        10
      )

    it "sets error flag", (done) ->
      promise = ->  new Promise (resolve) -> resolve()
      promise2 = -> new Promise (resolve) -> resolve()

      called = false
      called2 = false

      component = _promises: [ promise ]

      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe true
        expect(called).toBe true
        expect(called2).toBe false
        done()

      setTimeout(
        =>
          component._promises.push promise2
          called = true
          component._promises[0]()
          component._promises.push Promise.reject()
          setTimeout(
            =>
              called2 = true
              component._promises[1]()
            30
          )
        10
      )

    it "ignores errors", (done) ->
      promise = ->  new Promise (resolve) -> resolve()
      promise2 = -> new Promise (resolve) -> resolve()
      
      called = false
      called2 = false

      component =
        _promises: [ promise ]
        ignore_rejections: true

      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe undefined
        expect(called).toBe true
        expect(called2).toBe true
        done()

      setTimeout(
        =>
          component._promises.push promise2
          called = true
          component._promises[0]()
          component._promises.push Promise.reject()
          setTimeout(
            =>
              called2 = true
              component._promises[1]()
            30
          )
        10
      )

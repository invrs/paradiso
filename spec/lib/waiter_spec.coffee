Waiter = require "../../lib/paradiso/adapters/server/waiter"

describe "Waiter", ->
  describe "wait", ->
    it "waits for promises", (done) ->
      called   = false
      called2  = false
      promise = new Promise (resolve) ->
        setTimeout ->
          called = true
          promise2 = new Promise (resolve) ->
            setTimeout ->
              called2 = true
              resolve()
            , 10

          component._promises.push promise2
          resolve()
        , 10

      component = _promises: [ promise ]
      
      Waiter.wait(component).then ({ error }) =>
        console.log "thenning"
        expect(error).toBe undefined
        expect(called).toBe true
        expect(called2).toBe true
        done()

    it "sets error flag", (done) ->
      called   = false
      called2  = false
      promise = new Promise (resolve) ->
        setTimeout ->
          called = true
          promise2 = new Promise (resolve) ->
            setTimeout ->
              called2 = true
              resolve()
            , 10

          component._promises.push promise2
          component._promises.push Promise.reject()
          resolve()
        , 10

      component = _promises: [ promise ]

      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe true
        expect(called).toBe true
        expect(called2).toBe false
        done()

    it "ignores errors", (done) ->
      called   = false
      called2  = false
      promise = new Promise (resolve) ->
        setTimeout ->
          called = true
          promise2 = new Promise (resolve) ->
            setTimeout ->
              called2 = true
              resolve()
            , 10

          component._promises.push promise2
          component._promises.push Promise.reject()
          resolve()
        , 10

      component =
        _promises: [ promise ]
        ignore_rejections: true

      Waiter.wait(component).then ({ error }) =>
        expect(error).toBe undefined
        expect(called).toBe true
        expect(called2).toBe true
        done()

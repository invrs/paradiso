Paradiso = require "../../lib/paradiso"
request  = require "supertest"

describe "Paradiso", ->

  beforeEach ->
    @iso = new Paradiso(
      express: require "express"
      mithril: require "mithril"
    )

  describe "thing", ->
    it "works", (done) ->
      @iso.routes
        "/": class
          constructor: ->
            @title = @p "Welcome"
            @user  = @p @userModel()

          view: ->
            @homeView @

          HomeView: class
            constructor: ({ @title, @user }) ->

            header: ->
              "Hello, #{@user().name}"
            
            view: ->
              if @server
                @HTML [
                  @HEAD @TITLE @title()
                  @BODY @header()
                ]
              else
                @header()

          UserModel: class
            constructor: -> @name = "Joe"

      request(@iso.server.express)
        .get("/")
        .expect(200, "<html><head><title>Welcome</title></head><body>Hello, Joe</body></html>")
        .end (err, res) ->
          if err then throw err
          done()

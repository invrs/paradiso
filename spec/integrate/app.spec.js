import Immutable from "immutable"
import paradiso from "../../lib/paradiso"
import server from "../../lib/paradiso/server"

let app = undefined

describe("app", () => {
  beforeEach(() => {
    app = paradiso(class {
      client() {
        return this.paradiso.client({
          router: this.router(),
          type:   "mithril"
        })
      }

      router() {
        return this.paradiso.router({
          "/": "../components/home"
        })
      }

      server() {
        return this.paradiso.server({
          port:   9000,
          router: this.router(),
          static: "public",
          type:   "express"
        })
      }
    })
  })

  it("works", () => {
    console.log(app().server().then({}))
  })
})

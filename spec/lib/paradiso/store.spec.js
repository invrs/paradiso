import Immutable from "immutable"
import store from "../../../lib/paradiso/store"

describe("store", () => {
  it("makes constructor options immutable", (done) => {
    store(class {
      constructor(options) {
        expect(options).toEqual(
          Immutable.fromJS({ a: "b", key: "default" })
        )
        done()
      }
    })({ a: "b" })
  })

  it("makes update options immutable", (done) => {
    let def = store(class {
      constructor(options) {
        this.options = options
      }

      set(options) {
        expect(options).toEqual(
          Immutable.fromJS({ a: "c", key: "default" })
        )
        done()
      }
    })
    def({ a: "b" })
    def({ a: "c" })
  })
})

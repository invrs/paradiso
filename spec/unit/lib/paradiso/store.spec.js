import Immutable from "immutable"
import store from "../../../../lib/paradiso/store"

describe("store", () => {
  it("stores constructor options", () => {
    expect(store({ a: "b" }).options).toEqual(
      Immutable.fromJS({ a: "b", key: "default" })
    )
  })

  it("stores updated options", () => {
    store({ a: "b" })
    expect(store({ a: "c" }).options).toEqual(
      Immutable.fromJS({ a: "c", key: "default" })
    )
  })
})

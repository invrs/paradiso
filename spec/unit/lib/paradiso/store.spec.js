import Immutable from "immutable"
import store from "../../../../lib/paradiso/store"

describe("store", () => {
  it("stores constructor options", () => {
    console.log("!!!")
    expect(store({ a: "b" }).options).toEqual(
      Immutable.fromJS({ a: "b", key: "default" })
    )
  })

  it("stores updated options", () => {
    console.log("!!!2")
    store({ a: "b" })
    expect(store({ a: "c" }).options).toEqual(
      Immutable.fromJS({ a: "c", key: "default" })
    )
  })
})

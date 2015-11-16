import Immutable from "immutable"
import route from "../../../lib/paradiso/route"

describe("route", () => {
  it("works", (done) => {
    console.log(route({ a: "b" }).route.store())
    console.log(route({ b: "c" }).route.store())
  })
})

import definite from "definite"
import Immutable from "immutable"

class Store {
  constructor(options) {
    this.options = Immutable.fromJS(options)
  }

  set(options) {
    this.options = this.options.mergeDeep(options)
  }
}

export default definite(Store)

import definite from "definite"
import Immutable from "immutable"

class Store {
  constructor(options) {
    this.options = Immutable.fromJS(options)
  }

  merge(options) {
    return this.options.mergeDeep(options)
  }

  set(options) {
    return this.options = this.merge(options)
  }
}

export default definite(Store)

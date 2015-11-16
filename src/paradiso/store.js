import def from "definite"
import Immutable from "immutable"

let mixin = (Extend) =>
  class Store extends Extend {
    constructor(options) {
      options = Immutable.fromJS(options)
      super(options)
    }
  
    set(options) {
      super.set(this.options.mergeDeep(options))
    }
  }

export default def({ mixins: [ mixin ] })

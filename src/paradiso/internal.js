import definite from "definite"

let mixin = (Extend) =>
  class Internal extends Extend {
    constructor(options) {
      console.log("this.store constructor")
      super(options)
      this.store(options)
    }

    get get() {
      console.log("get")
      return this.store().options.get
    }

    set(options) {
      console.log("this.store set")
      return this.store(options)
    }
  }

export default definite({
  autoload: [ `${__dirname}` ],
  mixins:   [ mixin ]
})

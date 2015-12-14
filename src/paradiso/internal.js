import definite from "definite"

let mixin = Extend =>
  class Internal extends Extend {
    constructor(options) {
      super(options)
      this.store(options)
    }

    get(key) {
      if (key) {
        return this.store().options.get(key)
      }
      else {
        return this.store().options
      }
    }

    set(options) {
      return this.store(options)
    }

    then(options) {
      return super.then(this.store().merge(options))
    }
  }

export default definite({
  autoload: [ __dirname ],
  mixins:   [ mixin ]
})

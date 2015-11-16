import store from "./store"

class RouteStore {
  constructor(options) {
    this.options = options
  }

  set(options) {
    this.options = options
  }
}

export default store(RouteStore)

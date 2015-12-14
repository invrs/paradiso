import internal from "./internal"

class Server {
  then(options) {
    let adapter = this.server[this.get(`type`)]
    options = this.get()

    return adapter(options)
  }
}

export default internal(Server)

import internal from "./internal"

class Client {
  then() {
    let adapter = this.client[this.get(`type`)]
    let options = this.store().options

    return adapter(options)
  }
}

export default internal(Client)

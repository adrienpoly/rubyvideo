import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "title"

  connect() {
    super.connect()

    console.log("hello")

    this.send("connect", { title: this.title }, () => {
      console.log("react")
    })
  }

  get title() {
    return this.element.getAttribute("title")
  }
}

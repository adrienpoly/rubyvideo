import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "button"

  connect() {
    super.connect()

    this.send("connect", { title: this.title }, () => {
      this.element.click()
    })
  }

  get title() {
    return this.bridgeElement.bridgeAttribute("title")
  }
}

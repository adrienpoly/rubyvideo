import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { name: String, fade: Boolean };

  connect() {
    this.element.addEventListener("click", this.click.bind(this));
  }

  async click(event) {
    const img =
      event.currentTarget.querySelector("img") ||
      this.element.querySelector("div.video");
    img.style.viewTransitionName = this.nameValue;
  }
}

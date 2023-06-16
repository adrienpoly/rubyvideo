import { Controller } from "@hotwired/stimulus";
import { useDebounce } from "stimulus-use";

export default class extends Controller {
  static debounces = ["submit"];

  initialize() {
    useDebounce(this);
    console.log("object");
    this.element.addEventListener("keydown", () => this.submit());
  }

  submit() {
    this.element.requestSubmit();
  }
}

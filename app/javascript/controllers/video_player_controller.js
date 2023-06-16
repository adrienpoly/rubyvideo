import { Controller } from "@hotwired/stimulus";
import "vlitejs/dist/vlite.css";
import Vlitejs from "vlitejs";
import VlitejsYoutube from "vlitejs/dist/providers/youtube";

Vlitejs.registerProvider("youtube", VlitejsYoutube);

export default class extends Controller {
  static values = { poster: String, src: String, provider: String };
  static targets = ["player"];

  connect() {
    this.player = new Vlitejs(this.playerTarget, {
      provider: this.hasProviderValue ? this.providerValue : "youtube",
      options: {
        poster: this.posterValue,
      },
    });
  }
}

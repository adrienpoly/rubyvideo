import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    requestAnimationFrame(() => {
      const elementsWithViewTransitionName = document.querySelectorAll(
        "[style*='view-transition-name']"
      );
      elementsWithViewTransitionName.forEach((element) => {
        element.style.viewTransitionName = "";
      });
    });
  }
}

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['overlay', 'menu']

  connect () {
    this.overlayTarget.classList.remove('hidden')
    this.menuTarget.classList.remove('hidden')
  }

  closeVisibility () {
    this.overlayTarget.classList.add('hidden')
    this.menuTarget.classList.add('hidden')
  }

  toggleVisibility () {
    this.overlayTarget.classList.toggle('hidden')
    this.menuTarget.classList.toggle('hidden')
  }

  syncCheckboxes (event) {
    const responsiveCheckbox = event.target
    let responsiveCheckboxId = responsiveCheckbox.id

    // change the id of the checkbox to match the other one
    if (responsiveCheckboxId.includes('mobile-')) {
      responsiveCheckboxId = responsiveCheckboxId.replace('filter-mobile-', 'filter-')
    } else {
      responsiveCheckboxId = responsiveCheckboxId.replace('filter-', 'filter-mobile-')
    }

    document.getElementById(responsiveCheckboxId).checked = responsiveCheckbox.checked
  }
}

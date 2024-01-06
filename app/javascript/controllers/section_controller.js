import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['content', 'plus', 'minus']

  toggleVisibility () {
    this.contentTarget.classList.toggle('hidden')
    this.toggleIcons()
  }

  toggleIcons () {
    if (this.contentTarget.classList.contains('hidden')) {
      this.showPlusIcon()
    } else {
      this.showMinusIcon()
    }
  }

  showPlusIcon () {
    this.plusTarget.classList.remove('hidden')
    this.minusTarget.classList.add('hidden')
  }

  showMinusIcon () {
    this.plusTarget.classList.add('hidden')
    this.minusTarget.classList.remove('hidden')
  }
}

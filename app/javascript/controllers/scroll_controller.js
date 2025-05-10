import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['container', 'gradient', 'card']

  connect () {
    this.checkScroll()
  }

  checkScroll () {
    if (this.isAtEnd) {
      this.buttonTarget.classList.add('hidden')
      this.gradientTarget.classList.add('hidden')
    } else {
      this.buttonTarget.classList.remove('hidden')
      this.gradientTarget.classList.remove('hidden')
    }
  }

  get isAtEnd() {
    return this.containerTarget.scrollLeft + this.containerTarget.offsetWidth >= this.containerTarget.scrollWidth - 1
  }
}

import { Controller } from '@hotwired/stimulus'
import { useClickOutside } from 'stimulus-use'

export default class extends Controller {
  static targets = ['summary', 'swap']

  connect () {
    useClickOutside(this)
    this.element.addEventListener('toggle', this.toggle.bind(this))
  }

  disconnect () {
    this.#close()
    this.element.removeEventListener('toggle', this.toggle)
  }

  clickOutside (event) {
    this.#close(event)
  }

  // Private

  toggle (event) {
    if (this.element.open) {
      this.element.setAttribute('aria-expanded', true)
      this.swapTarget.classList.add('swap-active')
    } else {
      this.element.setAttribute('aria-expanded', false)
      this.swapTarget.classList.remove('swap-active')
    }
  }

  #close (event) {
    this.element.open = false
  }
}

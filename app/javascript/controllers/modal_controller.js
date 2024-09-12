import { Controller } from '@hotwired/stimulus'
import { useClickOutside } from 'stimulus-use'

// Connects to data-controller="modal"
export default class extends Controller {
  static values = {
    open: Boolean
  }

  static targets = ['modalBox']

  initialize () {
    useClickOutside(this, { element: this.modalBoxTarget })
  }

  connect () {
    if (this.openValue) {
      this.open()
    }
  }

  disconnect () {
    this.close()
  }

  clickOutside (event) {
    this.close()
  }

  open () {
    this.element.showModal()
  }

  close (e) {
    e?.preventDefault()

    this.element.close()
  }
}

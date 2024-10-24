import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'type',
    'input'
  ]

  connect () {
    this.updateInputVisibility()
  }

  change () {
    if (this.typeTarget.value === 'custom') {
      this.inputTarget.value = ''
    } else {
      this.inputTarget.value = this.typeTarget.selectedOptions[0]?.textContent || ''
    }

    this.updateInputVisibility()
  }

  updateInputVisibility () {
    if (this.typeTarget.value === 'custom') {
      this.inputTarget.classList.remove('hidden')
    } else {
      this.inputTarget.classList.add('hidden')
    }
  }
}

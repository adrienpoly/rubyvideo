import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static debounces = ['submit']

  initialize () {
    useDebounce(this)

    this.element.querySelectorAll('input[type="checkbox"]').forEach((checkbox) => {
      checkbox.addEventListener('change', () => this.submit())
    })
    this.element.addEventListener('keydown', () => this.submit())
    this.element.addEventListener('search', () => this.submit())
  }

  disconnect () {
    this.element.querySelectorAll('input[type="checkbox"]').forEach((checkbox) => {
      checkbox.removeEventListener('change', () => this.submit())
    })
    this.element.removeEventListener('keydown', () => this.submit())
    this.element.removeEventListener('search', () => this.submit())
  }

  handleCheckbox (event) {
    event.preventDefault()
  }

  submit () {
    this.element.requestSubmit()
  }
}

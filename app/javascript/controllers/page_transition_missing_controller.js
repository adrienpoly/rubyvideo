import { Controller } from '@hotwired/stimulus'

const ONE_DAY = 24 * 60 * 60 * 1000 // 24 hours in milliseconds

export default class extends Controller {
  connect () {
    if (!document.startViewTransition && !this.isDismissed) {
      this.element.classList.remove('hidden')
    }
  }

  dismiss () {
    this.element.classList.add('hidden')
    this.#setCookie('page_transition_missing_dismissed', 'true', 1)
  }

  #setCookie (name, value, days) {
    const expires = new Date()
    expires.setTime(expires.getTime() + days * ONE_DAY)
    document.cookie =
      name +
      '=' +
      encodeURIComponent(value) +
      ';expires=' +
      expires.toUTCString() +
      ';path=/'
  }

  get isDismissed () {
    return document.cookie.includes('page_transition_missing_dismissed=true')
  }
}

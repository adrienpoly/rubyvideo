import { Controller } from '@hotwired/stimulus'

import '@splidejs/splide/css'
import { Splide } from '@splidejs/splide'

export default class extends Controller {
  connect () {
    this.#reset()

    if (!this.splide) {
      this.splide = new Splide(this.element, this.splideOptions)
      this.splide.mount()
    }

    this.hiddenSlides.forEach(slide =>
      slide.classList.remove('hidden')
    )
  }

  disconnect () {
    this.splide.destroy(true)
    this.splide = undefined
  }

  #reset () {
    this.element.querySelectorAll('.splide__pagination').forEach(slide => slide.remove())
  }

  get splideOptions () {
    return {
      type: 'fade',
      rewind: true,
      perPage: 1,
      autoplay: true
    }
  }

  get hiddenSlides () {
    return Array.from(
      this.element.querySelectorAll('.splide__slide .hidden')
    )
  }
}

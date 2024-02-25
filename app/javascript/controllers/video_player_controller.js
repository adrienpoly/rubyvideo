import { Controller } from '@hotwired/stimulus'
import Vlitejs from 'vlitejs'
import VlitejsYoutube from 'vlitejs/dist/providers/youtube'

Vlitejs.registerProvider('youtube', VlitejsYoutube)

export default class extends Controller {
  static values = { poster: String, src: String, provider: String }
  static targets = ['player']
  playbackRateOptions = [1, 1.25, 1.5, 1.75, 2]

  connect () {
    this.player = new Vlitejs(this.playerTarget, {
      provider: this.hasProviderValue ? this.providerValue : 'youtube',
      options: {
        poster: this.posterValue,
        controls: true
      },
      onReady: this.handlePlayerReady.bind(this)
    })
  }

  handlePlayerReady (player) {
    const controlBar = player.elements.container.querySelector('.v-controlBar')
    if (controlBar) {
      const volumeButton = player.elements.container.querySelector('.v-volumeButton')
      const playbackRateSelect = this.createPlaybackRateSelect(this.playbackRateOptions, player)
      volumeButton.parentNode.insertBefore(playbackRateSelect, volumeButton.nextSibling)
    }
  }

  createPlaybackRateSelect (options, player) {
    const playbackRateSelect = document.createElement('select')
    playbackRateSelect.className = 'v-playbackRateSelect v-controlButton'
    options.forEach(rate => {
      const option = document.createElement('option')
      option.value = rate
      option.textContent = rate + 'x'
      playbackRateSelect.appendChild(option)
    })

    playbackRateSelect.addEventListener('change', () => {
      player.instance.setPlaybackRate(parseFloat(playbackRateSelect.value))
    })

    return playbackRateSelect
  }
}

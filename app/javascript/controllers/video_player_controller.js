import { Controller } from '@hotwired/stimulus'
import Vlitejs from 'vlitejs'
import VlitejsYoutube from 'vlitejs/providers/youtube.js'
import youtubeSvg from '../../assets/images/icons/fontawesome/youtube-brands-solid.svg?raw'

Vlitejs.registerProvider('youtube', VlitejsYoutube)

export default class extends Controller {
  static values = { poster: String, src: String, provider: String }
  static targets = ['player']
  playbackRateOptions = [1, 1.25, 1.5, 1.75, 2]

  connect () {
    const providerOptions = {}

    if (this.hasProviderValue) {
      providerOptions.provider = this.providerValue
    }

    this.player = new Vlitejs(this.playerTarget, {
      ...providerOptions,
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
      const openInYouTube = this.createOpenInYouTube()
      volumeButton.parentNode.insertBefore(playbackRateSelect, volumeButton.nextSibling)
      volumeButton.parentNode.insertBefore(openInYouTube, volumeButton.previousSibling)
    }
    // for seekTo to work we need to store again the player instance
    this.player = player
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

  seekTo (event) {
    const { time } = event.params

    if (time) {
      this.player.seekTo(time)
    }
  }

  createOpenInYouTube () {
    const videoContainer = this.playerTarget
    const videoId = videoContainer.getAttribute('data-youtube-id')

    const handleYouTubePlay = () => {
      window.open(`https://www.youtube.com/watch?v=${videoId}`, '_blank')
      this.player.pause()
    }

    const videoPlayerIcon = document.createElement('button')
    videoPlayerIcon.className = 'v-openInYouTube v-controlButton'
    videoPlayerIcon.innerHTML = youtubeSvg
    videoPlayerIcon.addEventListener('click', handleYouTubePlay)

    const externalPlayButton = document.querySelector('.v-playOnYoutubeButton')
    if (externalPlayButton) {
      externalPlayButton.addEventListener('click', handleYouTubePlay)
    }

    return videoPlayerIcon
  }
}

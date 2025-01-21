import { Controller } from '@hotwired/stimulus'
import Vlitejs from 'vlitejs'
import YouTube from 'vlitejs/providers/youtube.js'
import Vimeo from 'vlitejs/providers/vimeo.js'
import youtubeSvg from '../../assets/images/icons/fontawesome/youtube-brands-solid.svg?raw'

Vlitejs.registerProvider('youtube', YouTube)
Vlitejs.registerProvider('vimeo', Vimeo)

export default class extends Controller {
  static values = {
    poster: String,
    src: String,
    provider: String,
    startSeconds: Number,
    endSeconds: Number
  }

  static targets = ['player']
  playbackRateOptions = [1, 1.25, 1.5, 1.75, 2]

  connect () {
    this.init()
  }

  init () {
    if (!this.hasPlayerTarget) return

    this.player = new Vlitejs(this.playerTarget, this.options)
  }

  get options () {
    const providerOptions = {}
    const providerParams = {}

    if (this.hasProviderValue && this.providerValue !== 'mp4') {
      providerOptions.provider = this.providerValue
    }

    if (this.hasStartSecondsValue) {
      providerParams.start = this.startSecondsValue
    }

    if (this.hasEndSecondsValue) {
      providerParams.end = this.endSecondsValue
    }

    return {
      ...providerOptions,
      options: {
        providerParams,
        poster: this.posterValue,
        controls: true
      },
      onReady: this.handlePlayerReady.bind(this)
    }
  }

  handlePlayerReady (player) {
    this.ready = true
    // for seekTo to work we need to store again the player instance
    this.player = player

    const controlBar = player.elements.container.querySelector('.v-controlBar')

    if (controlBar) {
      const volumeButton = player.elements.container.querySelector('.v-volumeButton')
      const playbackRateSelect = this.createPlaybackRateSelect(this.playbackRateOptions, player)
      volumeButton.parentNode.insertBefore(playbackRateSelect, volumeButton.nextSibling)

      if (this.providerValue === 'youtube') {
        const openInYouTube = this.createOpenInYoutube()
        volumeButton.parentNode.insertBefore(openInYouTube, volumeButton.previousSibling)
      }
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

  seekTo (event) {
    if (!this.ready) return

    const { time } = event.params

    if (time) {
      this.player.seekTo(time)
    }
  }

  pause () {
    if (!this.ready) return

    this.player.pause()
  }

  createOpenInYoutube () {
    const videoId = this.playerTarget.dataset.youtubeId

    const anchorTag = document.createElement('a')
    anchorTag.className = 'v-openInYouTube v-controlButton'
    anchorTag.innerHTML = youtubeSvg
    anchorTag.href = `https://www.youtube.com/watch?v=${videoId}`
    anchorTag.target = '_blank'
    anchorTag.dataset.action = 'click->video-player#pause'

    return anchorTag
  }
}

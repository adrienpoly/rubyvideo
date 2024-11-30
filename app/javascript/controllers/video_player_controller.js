import { Controller } from '@hotwired/stimulus'
import Vlitejs from 'vlitejs'
import VlitejsYoutube from 'vlitejs/providers/youtube.js'

Vlitejs.registerProvider('youtube', VlitejsYoutube)

export default class extends Controller {
  static values = {
    poster: String,
    src: String,
    provider: String,
    startSeconds: Number,
    endSeconds: Number,
  }
  static targets = ['player']
  playbackRateOptions = [1, 1.25, 1.5, 1.75, 2]

  connect () {
    this.init()
  }

  init() {
    this.player = new Vlitejs(this.playerTarget, this.options)
  }

  get options() {
    const providerOptions = {}
    const providerParams = {}

    if (this.hasProviderValue) {
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
    const controlBar = player.elements.container.querySelector('.v-controlBar')
    if (controlBar) {
      const volumeButton = player.elements.container.querySelector('.v-volumeButton')
      const playbackRateSelect = this.createPlaybackRateSelect(this.playbackRateOptions, player)
      volumeButton.parentNode.insertBefore(playbackRateSelect, volumeButton.nextSibling)
    }
    // for seekTo to work we need to store again the player instance
    this.player = player
    // window.vlite = player

    // .addSecondsRange({ videoId: "dRBJxshD05E", startSeconds: 300, endSeconds: 400})

    // player.on('play', event => console.log("play", event));
    // player.on('progress', event => console.log("progress", event));
    // player.on('timeupdate', event => {
    //   // console.log(this.player)
    //   // console.log(event.timeStamp/1000)
    //   if (event.timeStamp/1000 >= 10) {
    //     // this.init()
    //     // console.log(this.player)
    //     // this.player.pause()
    //     // console.log("timeupdate", event)
    //   }
    // });
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
      if (this.hasStartSecondsValue && time < this.startSecondsValue) time = this.startSecondsValue
      if (this.hasEndSecondsValue && time > this.endSecondsValue) time = this.endSecondsValue

      this.player.seekTo(time)
    }
  }
}

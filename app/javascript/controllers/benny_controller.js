import { Controller } from "@hotwired/stimulus"

const MSGS = [
  "今日は何から始める？♡",
  "お水飲もう！💧",
  "ゲームも遊ぼ！🎮",
  "今日も会えて嬉しい♡",
  "一緒に頑張ろうね♪",
  "いい調子だよ！✨",
  "小さなことからでもOK！",
]

export default class extends Controller {
  static targets = ["img", "bubble"]

  connect() {
    this._startSpeech()
    this._startBlink()
  }

  disconnect() {
    clearInterval(this._speechTimer)
    clearInterval(this._blinkTimer)
  }

  _startSpeech() {
    if (!this.hasBubbleTarget) return
    this.bubbleTarget.textContent = MSGS[Math.floor(Math.random() * MSGS.length)]
    this._speechTimer = setInterval(() => {
      const next = MSGS[Math.floor(Math.random() * MSGS.length)]
      this.bubbleTarget.classList.add("tasks-zero-bubble--fade")
      setTimeout(() => {
        this.bubbleTarget.textContent = next
        this.bubbleTarget.classList.remove("tasks-zero-bubble--fade")
      }, 280)
    }, 5000)
  }

  _startBlink() {
    if (!this.hasImgTarget) return
    const doBlink = () => {
      this.imgTarget.classList.add("tasks-zero-img--blink")
      setTimeout(() => this.imgTarget.classList.remove("tasks-zero-img--blink"), 220)
    }
    const scheduleNext = () => {
      this._blinkTimer = setTimeout(() => { doBlink(); scheduleNext() }, 7000 + Math.random() * 5000)
    }
    scheduleNext()
  }
}

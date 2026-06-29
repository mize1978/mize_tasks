import { Controller } from "@hotwired/stimulus"

const TIME_LIMIT     = 30
const SPAWN_MS       = 600
const RIBBON_LIFE_MS = 3500
const MAX_LIVES      = 3

// タイプ定義: [type, emoji, pts, cumProb]
const RIBBON_TYPES = [
  { type: "rainbow", emoji: "🎀", pts: 10, prob: 0.03 },
  { type: "gold",    emoji: "🎀", pts: 5,  prob: 0.12 },
  { type: "heart",   emoji: "❤️", pts: 0,  prob: 0.07 },
  { type: "small",   emoji: "🎀", pts: 2,  prob: 0.10 },
  { type: "zigzag",  emoji: "🎀", pts: 1,  prob: 0.18 },
  { type: "spin",    emoji: "🎀", pts: 1,  prob: 0.18 },
  { type: "normal",  emoji: "🎀", pts: 1,  prob: 1.00 },
]

const RESULT_MESSAGES = {
  low:    ["次は絶対もっとできるよ！♪", "練習あるのみ！一緒に頑張ろうね♡", "ゆっくりでも大丈夫だよ♪"],
  mid:    ["よく頑張ったね！", "リボンをたくさんキャッチしたね♪", "かなり上手くなってきた！"],
  high:   ["すごい！！天才かも♡", "リボンハンターの素質あり✨", "最高スコア更新したかも！？"],
  perfect:["神業だよ！！👑", "リボンちゃん大感激♡♡", "もしかして…チート？笑 最高すぎる！"],
}

export default class extends Controller {
  static targets = [
    "startScreen", "gameScreen", "resultScreen",
    "countdown", "timer", "scoreDisplay",
    "ribbonContainer", "heart",
    "resultScore", "resultCoins", "resultMessage", "resultHighScore"
  ]

  connect() {
    this.score    = 0
    this.lives    = MAX_LIVES
    this.timeLeft = TIME_LIMIT
    this.active   = false
    this.combo    = 0
  }

  start() {
    this.score    = 0
    this.combo    = 0
    this.lives    = MAX_LIVES
    this.timeLeft = TIME_LIMIT
    this.startScreenTarget.hidden = true
    this.gameScreenTarget.hidden  = false
    this.scoreDisplayTarget.textContent = "0"
    this.timerTarget.textContent        = TIME_LIMIT
    this.timerTarget.classList.remove("game-timer--danger")
    this._renderHearts()
    this._countdown(3)
  }

  _countdown(n) {
    const el = this.countdownTarget
    el.hidden = false
    el.textContent = n > 0 ? n : "GO！"
    el.classList.toggle("game-countdown--go", n === 0)
    if (n > 0) {
      setTimeout(() => this._countdown(n - 1), 700)
    } else {
      setTimeout(() => { el.hidden = true; this._startGame() }, 500)
    }
  }

  _startGame() {
    this.active = true
    this.timerInterval = setInterval(() => {
      this.timeLeft--
      this.timerTarget.textContent = this.timeLeft
      if (this.timeLeft <= 5) this.timerTarget.classList.add("game-timer--danger")
      if (this.timeLeft <= 0) this._endGame()
    }, 1000)
    this.spawnInterval = setInterval(() => { if (this.active) this._spawnRibbon() }, SPAWN_MS)
    this._spawnRibbon()
  }

  _pickType() {
    const r = Math.random()
    let cum = 0
    for (const t of RIBBON_TYPES) {
      cum += t.prob
      if (r < cum) return t
    }
    return RIBBON_TYPES[RIBBON_TYPES.length - 1]
  }

  _spawnRibbon() {
    const def       = this._pickType()
    const container = this.ribbonContainerTarget
    const w = container.offsetWidth
    const h = container.offsetHeight
    const side = Math.floor(Math.random() * 4)
    let sx, sy, tx, ty

    if (side === 0)      { sx = Math.random()*w; sy = -56;   tx = (Math.random()-0.5)*w*0.6; ty = h+80; }
    else if (side === 1) { sx = w+56; sy = Math.random()*h;  tx = -(w+80); ty = (Math.random()-0.5)*h*0.6; }
    else if (side === 2) { sx = Math.random()*w; sy = h+56;  tx = (Math.random()-0.5)*w*0.6; ty = -(h+80); }
    else                 { sx = -56; sy = Math.random()*h;   tx = w+80;   ty = (Math.random()-0.5)*h*0.6; }

    const fontSize =
      def.type === "small"   ? 28 + Math.random()*10 :
      def.type === "spin"    ? 60 + Math.random()*16 :
      def.type === "gold"    ? 58 + Math.random()*14 :
      def.type === "rainbow" ? 62 + Math.random()*14 :
      def.type === "heart"   ? 52 + Math.random()*10 :
      48 + Math.random()*18

    const speed =
      def.type === "small"   ? 1.4 + Math.random()*0.8 :
      def.type === "zigzag"  ? 2.8 + Math.random()*0.8 :
      def.type === "rainbow" ? 3.0 + Math.random()*1.0 :
      2.0 + Math.random()*1.2

    const el = document.createElement("div")
    el.className  = ["game-ribbon", `game-ribbon--${def.type}`].join(" ")
    el.textContent = def.emoji
    el.dataset.type = def.type
    el.dataset.pts  = def.pts

    el.style.cssText = `
      left:${sx}px; top:${sy}px;
      --tx:${tx}px; --ty:${ty}px;
      --zx:${(Math.random()-0.5)*80}px;
      animation-duration:${speed}s;
      font-size:${fontSize}px;
    `

    el.addEventListener("pointerdown", (e) => {
      e.preventDefault()
      if (!this.active) return
      this._tap(el, e)
    }, { once: true })

    container.appendChild(el)

    const timer = setTimeout(() => {
      if (el.parentNode) el.remove()
    }, RIBBON_LIFE_MS)
    el._expireTimer = timer
  }

  _tap(el, e) {
    clearTimeout(el._expireTimer)
    const pts  = parseInt(el.dataset.pts) || 1
    const type = el.dataset.type

    const rect = el.getBoundingClientRect()
    const cx = rect.left + rect.width  / 2
    const cy = rect.top  + rect.height / 2

    el.classList.add("game-ribbon--popping")
    setTimeout(() => el.remove(), 220)

    if (type === "heart") {
      this._gainLife(cx, cy)
    } else {
      this.score += pts
      this.combo++
      this.scoreDisplayTarget.textContent = this.score
      this._sparkle(cx, cy, type)
      this._floatPlus(cx, cy, pts, type)
      this._pulseHeart()
      this._checkCombo()
    }
  }

  _gainLife(cx, cy) {
    if (this.lives < MAX_LIVES) {
      this.lives++
      this._renderHearts()
    }
    // ❤️ フロート
    const el = document.createElement("div")
    el.className = "game-float-score game-float-score--heart"
    el.textContent = "❤️ +1 life"
    el.style.cssText = `left:${cx}px; top:${cy}px`
    document.body.appendChild(el)
    setTimeout(() => el.remove(), 900)
  }

  _renderHearts() {
    if (!this.hasHeartTarget) return
    this.heartTargets.forEach((h, i) => {
      h.textContent = i < this.lives ? "♥" : "♡"
      h.style.opacity = i < this.lives ? "1" : "0.30"
      h.style.color = i < this.lives ? "#ff4d80" : "#ff6ea6"
    })
  }

  _pulseHeart() {
    if (!this.hasHeartTarget) return
    const filled = this.heartTargets.filter((_, i) => i < this.lives)
    if (!filled.length) return
    const heart = filled[(this.combo - 1) % filled.length]
    heart.classList.remove("tg-hud-heart--pulse")
    void heart.offsetWidth
    heart.classList.add("tg-hud-heart--pulse")
    setTimeout(() => heart.classList.remove("tg-hud-heart--pulse"), 400)
  }

  _checkCombo() {
    const msgs = { 10: "Perfect! ✨", 20: "Ribbon Master! 🎀", 30: "Amazing! 👑" }
    const msg = msgs[this.combo]
    if (msg) this._showComboMsg(msg)
  }

  _showComboMsg(text) {
    const el = document.createElement("div")
    el.className   = "tg-combo-msg"
    el.textContent = text
    document.body.appendChild(el)
    setTimeout(() => el.remove(), 900)
  }

  _sparkle(x, y, type = "normal") {
    const el = document.createElement("div")
    el.className = "game-sparkle" + (type === "gold" ? " game-sparkle--gold" : type === "rainbow" ? " game-sparkle--rainbow" : "")
    el.style.cssText = `left:${x}px; top:${y}px`
    for (let i = 0; i < 8; i++) {
      const p = document.createElement("span")
      p.style.setProperty("--angle", (i * 45) + "deg")
      el.appendChild(p)
    }
    document.body.appendChild(el)
    setTimeout(() => el.remove(), 600)
  }

  _floatPlus(x, y, pts = 1, type = "normal") {
    const el = document.createElement("div")
    const cls = pts >= 10 ? "game-float-score--rainbow"
              : pts >= 5  ? "game-float-score--gold"
              : pts >= 2  ? "game-float-score--bonus"
              : ""
    el.className = `game-float-score ${cls}`.trim()
    el.innerHTML = pts >= 5
      ? `✨ +${pts}!!`
      : `✨ +${pts} <span class='game-float-heart'>♡</span>`
    el.style.cssText = `left:${x}px; top:${y}px`
    document.body.appendChild(el)
    setTimeout(() => el.remove(), 800)
  }

  _endGame() {
    this.active = false
    clearInterval(this.timerInterval)
    clearInterval(this.spawnInterval)
    this.ribbonContainerTarget.innerHTML = ""

    const score = this.score
    const coins = score >= 100 ? 100 : score >= 50 ? 50 : 20
    const cat   = score >= 100 ? "perfect" : score >= 50 ? "high" : score >= 20 ? "mid" : "low"
    const msgs  = RESULT_MESSAGES[cat]
    const msg   = msgs[Math.floor(Math.random() * msgs.length)]

    this.resultScoreTarget.textContent   = score
    this.resultCoinsTarget.textContent   = `+${coins} コイン`
    this.resultMessageTarget.textContent = msg

    this.gameScreenTarget.hidden   = true
    this.resultScreenTarget.hidden = false

    fetch(this.element.dataset.tapGameResultUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({ score }),
    })
    .then(r => r.json())
    .then(data => {
      if (data.error) return
      if (this.hasResultHighScoreTarget) {
        const hs = parseInt(this.resultHighScoreTarget.dataset.prev || 0)
        if (score > hs) {
          this.resultHighScoreTarget.textContent = `🏆 ハイスコア更新！ ${score} 点`
          this.resultHighScoreTarget.classList.add("game-result-hs--new")
        } else {
          this.resultHighScoreTarget.textContent = `ハイスコア: ${hs} 点`
        }
      }
    })
  }

  retry() {
    this.resultScreenTarget.hidden = true
    this.startScreenTarget.hidden  = false
  }

  disconnect() {
    clearInterval(this.timerInterval)
    clearInterval(this.spawnInterval)
    this.active = false
  }
}

import { Controller } from "@hotwired/stimulus"

const SIZE = 4

export default class extends Controller {
  static targets = [
    "startScreen", "gameScreen", "resultScreen",
    "board", "moveCount", "timer",
    "previewImg",
    "resultMoves", "resultTime", "resultCoins", "resultUnlock", "resultPlaysLeft", "resultClears",
    "playAgainBtn"
  ]

  connect() {
    this.tiles = []
    this.moves = 0
    this.seconds = 0
    this.timerInterval = null
    this.imageUrl = this.element.dataset.puzzleImage
    this.resultUrl = this.element.dataset.puzzleResultUrl
    this.selectUrl = this.element.dataset.puzzleSelectUrl
  }

  disconnect() {
    clearInterval(this.timerInterval)
  }

  // ─── 絵柄選択 ─────────────────────────────────────────────
  async selectPuzzle(e) {
    const item = e.currentTarget
    const puzzleId = item.dataset.puzzleId
    const file = item.dataset.puzzleFile
    if (!file) return

    try {
      const resp = await fetch(this.selectUrl, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ puzzle_id: puzzleId })
      })
      const data = await resp.json()
      if (resp.ok) {
        this.imageUrl = data.image_url
        if (this.hasPreviewImgTarget) this.previewImgTarget.src = data.image_url

        // 選択状態を更新
        this.element.querySelectorAll(".pz-gallery-item").forEach(el => {
          el.classList.remove("pz-gallery-item--selected")
          el.querySelector(".pz-gallery-check")?.remove()
        })
        item.classList.add("pz-gallery-item--selected")
        const check = document.createElement("span")
        check.className = "pz-gallery-check"
        check.textContent = "✓"
        item.appendChild(check)
      }
    } catch { /* silent */ }
  }

  // ─── ゲーム開始 ───────────────────────────────────────────
  start() {
    this.moves = 0
    this.seconds = 0
    this.moveCountTarget.textContent = "0"
    this.timerTarget.textContent = "0:00"

    this.initBoard()
    this.shuffleBoard()
    this.renderBoard()

    this.startScreenTarget.hidden = true
    this.gameScreenTarget.hidden = false
    this.resultScreenTarget.hidden = true

    clearInterval(this.timerInterval)
    this.timerInterval = setInterval(() => this.tickTimer(), 1000)
  }

  shuffle() {
    this.shuffleBoard()
    this.renderBoard()
    this.moves = 0
    this.moveCountTarget.textContent = "0"
  }

  playAgain() {
    this.startScreenTarget.hidden = false
    this.gameScreenTarget.hidden = true
    this.resultScreenTarget.hidden = true
  }

  // ─── ボードロジック ────────────────────────────────────────
  initBoard() {
    this.tiles = [...Array(SIZE * SIZE - 1).keys()].map(i => i + 1)
    this.tiles.push(null)
  }

  emptyIndex() { return this.tiles.indexOf(null) }

  canMove(idx) {
    const empty = this.emptyIndex()
    const row = Math.floor(idx / SIZE), col = idx % SIZE
    const eRow = Math.floor(empty / SIZE), eCol = empty % SIZE
    return (row === eRow && Math.abs(col - eCol) === 1) ||
           (col === eCol && Math.abs(row - eRow) === 1)
  }

  moveTile(idx) {
    if (!this.canMove(idx)) return false
    const empty = this.emptyIndex()
    this.tiles[empty] = this.tiles[idx]
    this.tiles[idx] = null
    return true
  }

  shuffleBoard() {
    let last = -1
    for (let i = 0; i < 300; i++) {
      const empty = this.emptyIndex()
      const neighbors = this.getNeighbors(empty).filter(n => n !== last)
      const pick = neighbors[Math.floor(Math.random() * neighbors.length)]
      last = empty
      this.tiles[empty] = this.tiles[pick]
      this.tiles[pick] = null
    }
  }

  getNeighbors(idx) {
    const row = Math.floor(idx / SIZE), col = idx % SIZE
    const result = []
    if (row > 0) result.push(idx - SIZE)
    if (row < SIZE - 1) result.push(idx + SIZE)
    if (col > 0) result.push(idx - 1)
    if (col < SIZE - 1) result.push(idx + 1)
    return result
  }

  isSolved() {
    for (let i = 0; i < SIZE * SIZE - 1; i++) {
      if (this.tiles[i] !== i + 1) return false
    }
    return this.tiles[SIZE * SIZE - 1] === null
  }

  // ─── 描画 ──────────────────────────────────────────────────
  renderBoard() {
    const board = this.boardTarget
    board.innerHTML = ""
    board.style.setProperty("--pz-size", SIZE)

    this.tiles.forEach((val, idx) => {
      const tile = document.createElement("div")
      tile.className = "pz-tile" + (val === null ? " pz-tile--empty" : "")

      if (val !== null) {
        const origRow = Math.floor((val - 1) / SIZE)
        const origCol = (val - 1) % SIZE
        tile.style.backgroundImage = `url('${this.imageUrl}')`
        tile.style.backgroundSize = `${SIZE * 100}% ${SIZE * 100}%`
        tile.style.backgroundPosition =
          `${origCol * (100 / (SIZE - 1))}% ${origRow * (100 / (SIZE - 1))}%`
        tile.dataset.idx = idx
        tile.addEventListener("click", () => this.handleTileClick(idx))
      }

      board.appendChild(tile)
    })
  }

  handleTileClick(idx) {
    if (!this.canMove(idx)) return
    this.moveTile(idx)
    this.moves++
    this.moveCountTarget.textContent = this.moves
    this.renderBoard()
    if (this.isSolved()) this.onSolved()
  }

  // ─── タイマー ─────────────────────────────────────────────
  tickTimer() {
    this.seconds++
    const m = Math.floor(this.seconds / 60)
    const s = String(this.seconds % 60).padStart(2, "0")
    this.timerTarget.textContent = `${m}:${s}`
  }

  formatTime(sec) {
    const m = Math.floor(sec / 60)
    const s = String(sec % 60).padStart(2, "0")
    return `${m}:${s}`
  }

  // ─── クリア ────────────────────────────────────────────────
  async onSolved() {
    clearInterval(this.timerInterval)

    this.resultMovesTarget.textContent = `${this.moves} 手`
    this.resultTimeTarget.textContent = this.formatTime(this.seconds)

    try {
      const resp = await fetch(this.resultUrl, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Content-Type": "application/json"
        }
      })
      const data = await resp.json()

      if (resp.ok) {
        this.resultClearsTarget.textContent = `${data.clears} 回`
        this.resultCoinsTarget.innerHTML =
          `<span class="pz-coins-got">🪙 +${data.coins} コイン</span>` +
          `<span class="pz-coins-total">合計: ${data.total_coins} コイン</span>`

        if (data.newly_unlocked?.length > 0) {
          const names = data.newly_unlocked.map(p => `「${p.name}」`).join("、")
          this.resultUnlockTarget.innerHTML =
            `<div class="pz-unlock-banner">🎉 新しいパズル解放！<br><strong>${names}</strong></div>`
        }

        if (data.plays_left > 0) {
          this.resultPlaysLeftTarget.textContent = `あと ${data.plays_left} 回遊べるよ！`
          this.playAgainBtnTarget.hidden = false
        } else {
          this.resultPlaysLeftTarget.textContent = "今日の挑戦回数を使い切ったよ！また明日♡"
          this.playAgainBtnTarget.hidden = true
        }
      } else if (data.error === "played_out") {
        this.resultCoinsTarget.innerHTML = `<span class="pz-coins-note">今日の報酬はもう受け取ったよ♡</span>`
        this.playAgainBtnTarget.hidden = true
      }
    } catch {
      this.resultCoinsTarget.innerHTML = `<span class="pz-coins-note">通信エラーが発生しました</span>`
    }

    this.gameScreenTarget.hidden = true
    this.resultScreenTarget.hidden = false
  }
}

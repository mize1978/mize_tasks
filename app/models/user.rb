class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

def badge
  count = completed_count || 0

  case count
  when 0
    "まだないよ🥺"
  when 1..4
    "🌱 はじめの一歩"
  when 5..9
    "🍰 ごほうび上手"
  else
    "💖 がんばり屋さん"
  end
end

def ribbon_level
  case completed_count || 0
  when 0..9
    1
  when 10..29
    2
  when 30..59
    3
  when 60..99
    4
  else
    5
  end
end

def ribbon_title
  case ribbon_level
  when 1
    "たまごのリボン族"
  when 2
    "ぷちリボン族"
  when 3
    "リボン族"
  when 4
    "上位リボン族"
  else
    "マスターリボン族"
  end
end

def ribbon_stage
  count = completed_count || 0
  if    count >= 70 then 5
  elsif count >= 40 then 4
  elsif count >= 20 then 3
  elsif count >= 10 then 2
  else                   1
  end
end

def ribbon_stage_name
  %w[ふしぎなたまご ぷちリボン ベイビーリボン 夜桜リボン プリンセスリボン][ribbon_stage - 1]
end

def ribbon_exp
  count = completed_count || 0
  case ribbon_stage
  when 1 then count
  when 2 then count - 10
  when 3 then count - 20
  when 4 then count - 40
  when 5 then count - 70
  end
end

def ribbon_exp_max
  [10, 10, 20, 30, nil][ribbon_stage - 1]
end

def ribbon_exp_percent
  count = completed_count || 0
  case ribbon_stage
  when 1 then (count * 10).clamp(0, 100)
  when 2 then ((count - 10) * 10).clamp(0, 100)
  when 3 then ((count - 20) * 5).clamp(0, 100)
  when 4 then ((count - 40) * 100 / 30).clamp(0, 100)
  when 5 then 100
  end
end

def next_stage_tasks
  count = completed_count || 0
  case ribbon_stage
  when 1 then 10 - count
  when 2 then 20 - count
  when 3 then 40 - count
  when 4 then 70 - count
  when 5 then 0
  end
end


def ribbon_message
  case ribbon_level
  when 1
    "今日も進んでるね♪"
  when 2
    "がんばりが見えてきたよ！"
  when 3
    "ごほうび上手になってきたね🍰"
  when 4
    "すごい！どんどん成長してる！"
  else
    "もう習慣化マスターだね👑"
  end
end

# app/models/user.rb

def ribbon_stage_image
  case ribbon_stage
  when 1 then "stage_egg.png"
  when 2 then "stage_petit.png"
  when 3 then "stage_baby.png"
  when 4 then "stage_ribbon.png"
  else        "stage_royal.png"
  end
end

def ribbon_stage_gold_bg?
  ribbon_stage == 3
end

  # ===== お部屋の背景 =====
  def room_bg_image
    bg = RoomBackground.find(current_room_bg || "default")
    bg ? bg[:image] : "room_stage_1.png"
  end

  def set_bg!(bg_id)
    bg = RoomBackground.find(bg_id)
    return false unless bg
    cost = current_room_bg == bg_id ? 0 : bg[:price]
    return false if coins < cost
    update!(coins: coins - cost, current_room_bg: bg_id)
    true
  end

  # ===== デイリーBOX =====
  BOX_PRIZES = [
    { type: :coins, amount: 10,  label: "コイン 10",     rarity: "normal", weight: 35 },
    { type: :coins, amount: 30,  label: "コイン 30",     rarity: "normal", weight: 25 },
    { type: :coins, amount: 50,  label: "コイン 50",     rarity: "good",   weight: 20 },
    { type: :coins, amount: 100, label: "コイン 100",    rarity: "good",   weight: 12 },
    { type: :exp,   amount: 3,   label: "EXP ボーナス",  rarity: "rare",   weight: 6  },
    { type: :coins, amount: 350, label: "コイン 350!!!",  rarity: "super",  weight: 2  },
  ].freeze

  def box_available?
    last_box_opened_at.nil? || last_box_opened_at.to_date < Date.today
  end

  def open_box!
    return nil unless box_available?
    total  = BOX_PRIZES.sum { |p| p[:weight] }
    roll   = rand(total)
    cumul  = 0
    prize  = BOX_PRIZES.find { |p| (cumul += p[:weight]) > roll }
    case prize[:type]
    when :coins then increment!(:coins, prize[:amount])
    when :exp   then increment!(:completed_count, prize[:amount])
    end
    update!(
      last_box_opened_at: Time.current,
      last_box_prize: { type: prize[:type].to_s, label: prize[:label], rarity: prize[:rarity] }
    )
    prize
  end

  def today_prize
    return nil unless last_box_opened_at&.to_date == Date.today
    last_box_prize
  end

  # ===== お手紙 =====
  def available_letters
    Letter.all_for(self)
  end

  def letter_read?(id)
    Array(read_letter_ids).include?(id)
  end

  def read_letter!(id)
    return if letter_read?(id)
    update!(read_letter_ids: Array(read_letter_ids) + [id])
  end

  def unread_letter_count
    available_letters.count { |l| !letter_read?(l[:id]) }
  end

  validates :email, presence: true, uniqueness: true
  validates :nickname, presence: true
end
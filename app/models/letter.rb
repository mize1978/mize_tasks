class Letter
  CATALOG = [
    # ─── 常時届く（ウェルカム） ───────────────────────────────
    {
      id:          "welcome",
      from:        "リボンちゃん",
      icon:        "🎀",
      subject:     "はじめまして！ようこそリワードミへ",
      body:        "はじめまして！わたしはリボンちゃんだよ♪\n\nリワードミに来てくれてありがとう💕\nここでは、タスクをこなすたびにコインがもらえて、お部屋を飾ったり、わたしを育てたりできるよ。\n\nむずかしく考えなくていいの。小さな一歩でも、ちゃんとごほうびがもらえる仕組みになってるから♪\n\nこれからずっと、いっしょにがんばろうね！",
      trigger:     :always,
      received_at: "2026-06-01",
    },
    {
      id:          "box_intro",
      from:        "Reward運営",
      icon:        "🎁",
      subject:     "毎日のBOXについて",
      body:        "左のサイドバーに「今日のリボンBOX」があるの気づいた？\n\n毎日1回、BOXを開けるとコインやEXPがランダムでもらえるよ！\nレアなごほうびが出ることもあるから、毎日チェックしてみてね🌟\n\nBOXは毎朝リセットされるから、ログインのたびに忘れずに開けてね。\n\nたくさんコイン貯まるといいね♡",
      trigger:     :always,
      received_at: "2026-06-02",
    },
    {
      id:          "room_shop",
      from:        "マイルーム",
      icon:        "🏠",
      subject:     "新しい背景をプレゼント！",
      body:        "コインが貯まってきたら、ぜひショップを見てみてね！\n\n星空の部屋、スイーツの部屋、プリンセスの部屋…いろんな背景テーマがあって、お部屋の雰囲気をガラッと変えられるよ✨\n\nパートナーの色によって、似合う部屋も変わってくるから「自分だけの組み合わせ」を探してみてね。\n\nどの部屋でも、わたしはずっと一緒にいるよ💕",
      trigger:     :always,
      received_at: "2026-06-03",
    },

    # ─── パートナー決定 ───────────────────────────────────────
    {
      id:          "egg_friend",
      from:        "パートナー",
      icon:        "🥚",
      subject:     "これからよろしくね！",
      body:        "たまごの色を選んでくれてありがとう！\n\nこれでわたしたちは正式にパートナーだよ♡\n\nタスクをこなすたびに、わたしはどんどん成長していくよ。どんな姿になるか、楽しみにしててね♪\n\nいつもそばにいるから、なにかあったら話しかけてね。\nずっと応援してるよ！💕",
      trigger:     :egg_chosen,
      received_at: nil,
    },

    # ─── はじめてのタスク ─────────────────────────────────────
    {
      id:          "first_task",
      from:        "システム",
      icon:        "⭐",
      subject:     "初めてのタスク達成！",
      body:        "やったー！！\n\nはじめてのタスクを完了したね、すごいよ！えらい！！\n\nこの一歩が大きな習慣のはじまり。小さくても、ちゃんと積み上げていけば、絶対に変わっていけるから♪\n\nコインも貯まってきたら、お部屋の背景を変えてみてね🏠\nこれからもずっと応援してるよ！💕",
      trigger:     :first_task,
      received_at: nil,
    },

    # ─── 進化直前 ─────────────────────────────────────────────
    {
      id:          "evolution_near",
      from:        "リボンちゃん",
      icon:        "🌱",
      subject:     "もうすぐ進化するよ！",
      body:        "すごい！タスクをたくさんこなしてくれてるね！\n\nあともう少しで…わたし、進化するよ✨\n\nどんな姿になるか楽しみにしててね。右のパネルで確認できるよ♪\n\nリワードミを続けてくれてありがとう。\nこれからも一緒にがんばろうね！💕",
      trigger:     :evolution_near,
      received_at: nil,
    },

    # ─── レベル到達 ───────────────────────────────────────────
    {
      id:          "level_10",
      from:        "リボンちゃん",
      icon:        "🎀",
      subject:     "Lv10おめでとう！",
      body:        "わぁ！\n少し大きくなれたよ！\n\nLv10まで一緒に来れてうれしいな♪\nこれからもっと頑張るね！\n\nそれと…最近どう？ちゃんと休めてる？\n無理しすぎないでね💕",
      trigger:     :level_10,
      received_at: nil,
    },
    {
      id:          "level_20",
      from:        "リボンちゃん",
      icon:        "🎀",
      subject:     "夢を見たんだ",
      body:        "昨日夢を見たんだ！\n\n大きなお城みたいなお部屋だったよ♪\nきみも一緒にいて、すごく楽しかった。\n\nいつかほんとに、そんな部屋に住めるといいね…🏰\n\nLv20、すごいよ。今日は自分をいっぱいほめてね♡",
      trigger:     :level_20,
      received_at: nil,
    },
    {
      id:          "level_40",
      from:        "リボンちゃん",
      icon:        "🎀",
      subject:     "最近、思うことがあって",
      body:        "最近、一緒にいる時間が\nすごく楽しいな。\n\nいつの間にかこんなに続いてたんだね。\nきみのことをもっと知りたいな、って思う。\n\nLv40…ありがとう。本当に、大切な時間だよ♡",
      trigger:     :level_40,
      received_at: nil,
    },

    # ─── 部屋別 ───────────────────────────────────────────────
    {
      id:          "room_letter_star",
      from:        "夜空のお部屋",
      icon:        "🌙",
      subject:     "今夜の流れ星",
      body:        "今日は流れ星を見つけたよ。\n\nお願いごと、してみた？\n\nこの部屋にいると、なんだか願いが叶いそうな気がするね。\n\nきみと一緒に、星を数えたいな…✨",
      trigger:     :room_star,
      received_at: nil,
    },
    {
      id:          "room_letter_night_simple",
      from:        "星のちいさなお部屋",
      icon:        "🌙",
      subject:     "月が細くてきれいだよ",
      body:        "月が細くてきれいだよ。\n\nこの部屋から見える夜空、好きだな。\n\nいつか、もっと大きな星空を一緒に見たいね。\nそれまで、ここで待ってるよ♡",
      trigger:     :room_night_simple,
      received_at: nil,
    },
    {
      id:          "room_letter_sweets",
      from:        "スイーツのお部屋",
      icon:        "🍰",
      subject:     "甘い香りがするね♪",
      body:        "甘い香りがするね♪\n\nこの部屋にいると、なんだか幸せな気分になるの。\nケーキとか、クッキーとか…食べたくなってきた？\n\nごほうびに、何か甘いものを食べてもいいよ♡",
      trigger:     :room_sweets,
      received_at: nil,
    },
    {
      id:          "room_letter_sunny",
      from:        "ひだまりのお部屋",
      icon:        "☀️",
      subject:     "ぽかぽかして眠くなっちゃう…",
      body:        "ぽかぽかして眠くなっちゃう…\n\nこの部屋、日差しがあたたかくていいよね。\n\nひまわりも今日は元気そう♪\nきみもちゃんと休めてるといいな。\n\nがんばりすぎず、今日もよろしくね☀️",
      trigger:     :room_sunny,
      received_at: nil,
    },
  ].freeze

  def self.all_for(user)
    today = Date.current
    CATALOG.select { |l| available?(l, user, today) }
  end

  def self.find(id)
    CATALOG.find { |l| l[:id] == id }
  end

  def self.available?(letter, user, _today = Date.current)
    case letter[:trigger]
    when :always            then true
    when :egg_chosen        then user.egg_color.present?
    when :first_task        then (user.completed_count || 0) >= 1
    when :evolution_near    then (user.completed_count || 0) >= 8
    when :level_10          then (user.ribbon_level || 0) >= 10
    when :level_20          then (user.ribbon_level || 0) >= 20
    when :level_40          then (user.ribbon_level || 0) >= 40
    when :room_star         then user.current_room_bg == "star"
    when :room_night_simple then user.current_room_bg == "night_simple"
    when :room_sweets       then user.current_room_bg == "sweets"
    when :room_sunny        then user.current_room_bg == "sunny"
    else false
    end
  end
end

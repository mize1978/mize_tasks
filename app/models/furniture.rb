# お部屋に飾れる家具のカタログ（DBテーブルではなく定数で管理）
# top / left は部屋（.my-room）内での配置位置（％）
class Furniture
  CATALOG = [
    { id: "sofa",    name: "ソファ",       icon: "🛋️", image: nil,                    price: 50, top: 70, left: 8  },
    { id: "lamp",    name: "桜のランプ",   icon: "💡", image: "furniture_lamp.png",    price: 30, top: 34, left: 5  },
    { id: "plant",   name: "観葉植物",     icon: "🪴", image: nil,                    price: 40, top: 66, left: 90 },
    { id: "ribbon",  name: "リボン飾り",   icon: "🎀", image: nil,                    price: 20, top: 10, left: 70 },
    { id: "bear",    name: "くまさん",     icon: "🧸", image: nil,                    price: 60, top: 70, left: 66 },
    { id: "balloon", name: "風船",         icon: "🎈", image: nil,                    price: 35, top: 14, left: 40 },
    { id: "cake",    name: "ケーキ",       icon: "🍰", image: nil,                    price: 45, top: 74, left: 46 },
    { id: "star",    name: "スター",       icon: "⭐", image: nil,                    price: 25, top: 20, left: 24 }
  ].freeze

  def self.all
    CATALOG
  end

  def self.find(id)
    CATALOG.find { |f| f[:id] == id }
  end
end

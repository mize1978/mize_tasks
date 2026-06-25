class FurnituresController < ApplicationController
  before_action :require_login

  def shop
  end

  def toggle
    item = Furniture.find(params[:id])
    return redirect_to(request.referer || root_path, alert: "その家具は見つからないよ") unless item

    id     = item[:id]
    owned  = current_user.owned_furniture_ids.dup
    placed = current_user.placed_furniture_ids.dup

    if placed.include?(id)
      placed.delete(id)
      notice = "#{item[:name]}を片付けたよ"
    elsif owned.include?(id)
      placed << id
      notice = "#{item[:name]}をお部屋に飾ったよ♪"
    elsif current_user.coins >= item[:price]
      current_user.decrement!(:coins, item[:price])
      owned  << id
      placed << id
      notice = "#{item[:name]}を購入してお部屋に飾ったよ！（-#{item[:price]} コイン）"
    else
      return redirect_to(request.referer || root_path, alert: "コインが足りないよ…（#{item[:name]}は #{item[:price]} コイン）")
    end

    current_user.update(owned_furniture: owned, placed_furniture: placed)
    redirect_to request.referer || root_path, notice: notice
  end
end

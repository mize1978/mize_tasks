class RoomBackgroundsController < ApplicationController
  def set
    bg = RoomBackground.find(params[:id])
    return redirect_to shop_path, alert: "背景が見つかりません" unless bg

    unless RoomBackground.available_now?(bg)
      return redirect_to shop_path, alert: "#{bg[:event_label]}のみ入手できる限定背景です 🎁"
    end

    if current_user.set_bg!(bg[:id])
      redirect_to shop_path, notice: "「#{bg[:name]}」に変更しました 🏠"
    else
      redirect_to shop_path, alert: "コインが不足しています 🪙"
    end
  end
end

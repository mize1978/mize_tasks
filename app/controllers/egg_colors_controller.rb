class EggColorsController < ApplicationController
  skip_before_action :require_egg_color

  EGG_DEFAULT_ROOMS = {
    "pink"   => "default",
    "blue"   => "night_simple",
    "yellow" => "sunny"
  }.freeze

  def show
    color = params[:color]
    if color.present? && %w[pink blue yellow].include?(color)
      current_user.update!(egg_color: color, current_room_bg: EGG_DEFAULT_ROOMS[color])
      return redirect_to dashboard_path, notice: "✨ あなたのパートナーが決まりました！"
    end
    redirect_to dashboard_path if current_user.egg_color.present?
  end

  def update
    color = params[:color]
    return redirect_back(fallback_location: choose_egg_path) unless %w[pink blue yellow].include?(color)
    current_user.update!(egg_color: color, current_room_bg: EGG_DEFAULT_ROOMS[color])
    redirect_back fallback_location: dashboard_path, notice: "✨ パートナーカラーを変更しました！"
  end
end

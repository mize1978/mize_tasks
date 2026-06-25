class BoxesController < ApplicationController
  before_action :require_login

  def open
    unless current_user.box_available?
      render json: { error: "already_opened" }, status: :unprocessable_entity
      return
    end
    prize = current_user.open_box!
    render json: { prize: { label: prize[:label], rarity: prize[:rarity], type: prize[:type].to_s } }
  end
end

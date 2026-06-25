class LettersController < ApplicationController
  def index
    @letters  = Letter.all_for(current_user)
    @read_ids = Array(current_user.read_letter_ids)
  end

  def show
    @letter = Letter.find(params[:id])
    return redirect_to letters_path unless @letter
    return redirect_to letters_path unless Letter.available?(@letter, current_user)
    current_user.read_letter!(@letter[:id])
  end
end

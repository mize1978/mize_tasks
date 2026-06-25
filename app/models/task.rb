# app/models/task.rb
class Task < ApplicationRecord
  belongs_to :user

  CATEGORIES = %w[学習 健康 習慣 家事 仕事 その他].freeze

  def start_time
    date
  end
end
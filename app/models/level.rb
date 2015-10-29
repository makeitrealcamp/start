# == Schema Information
#
# Table name: levels
#
#  id              :integer          not null, primary key
#  name            :string
#  required_points :integer
#  image_url       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Level < ActiveRecord::Base
  has_many :users

  validates :name, presence: true

  default_scope { order('required_points ASC') }

  def self.for_points(user_points)
    level_diff = []
    Level.all.each do |level|
      diff = user_points - level.required_points
      level_diff.push(level_id: level.id, diff: diff) if diff >= 0
    end
    correct_level = level_diff.sort{|a, b| a[:diff] <=> b[:diff] }.first
    return nil if correct_level.nil?
    return Level.find(correct_level[:level_id])
  end

  def next
    Level.order(:required_points)
      .where("required_points > ?",self.required_points).first
  end

end

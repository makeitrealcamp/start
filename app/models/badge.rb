# == Schema Information
#
# Table name: badges
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  required_points :integer
#  image_url       :string
#  subject_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  giving_method   :integer
#

class Badge < ApplicationRecord
  belongs_to :subject
  has_many :badge_ownerships, dependent: :destroy

  validates :name, presence: true
  validates :image_url, presence:  true
  validates :giving_method, presence: true
  validates :required_points, presence: true, if: :points?
  validates :subject, presence: true, if: :points?

  enum giving_method: [:manually, :points]

  scope :granted_by_points, -> { points }
end

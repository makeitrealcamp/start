# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  name       :string
#  row        :integer
#  slug       :string
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  published  :boolean
#
# Indexes
#
#  index_quizzes_on_course_id  (course_id)
#

class Quizer::Quiz < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :course_id

  extend FriendlyId
  friendly_id :name

  belongs_to :course
  has_many :questions
  has_many :quiz_attempts

  validates :name, presence: true
  validates :course, presence: true

  after_initialize :defaults
  scope :for, -> user { published unless user.is_admin? }

  private

    def defaults
      self.published ||= false
      true
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

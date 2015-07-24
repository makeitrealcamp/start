# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string(50)
#  row           :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  time_estimate :string(50)
#  excerpt       :string
#  description   :string
#  slug          :string
#  published     :boolean
#  phase_id      :integer
#
# Indexes
#
#  index_courses_on_phase_id  (phase_id)
#

class Course < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :phase_id

  extend FriendlyId
  friendly_id :name

  has_many :resources
  has_many :challenges
  has_many :projects
  has_many :points
  belongs_to :phase
  has_many :badges, dependent: :destroy

  validates :name, presence: true
  scope :for, -> user { published unless user.is_admin? }
  scope :published, -> { where(published: true) }
  default_scope { rank(:row) }

  after_initialize :default_values

  def next
    self.phase.courses.published.where('row > ?', self.row).first
  end

  private
    def default_values
      self.published ||= false
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

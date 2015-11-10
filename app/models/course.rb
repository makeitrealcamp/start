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
#

class Course < ActiveRecord::Base
  include RankedModel
  ranks :row

  extend FriendlyId
  friendly_id :name

  has_many :resources
  has_many :challenges
  has_many :projects
  has_many :points
  has_many :quizzes, class_name: 'Quizer::Quiz'
  has_many :course_phases
  has_many :phases, -> { uniq }, through: :course_phases
  has_many :badges, dependent: :destroy

  validates :name, presence: true
  scope :for, -> user { published unless user.is_admin? }
  scope :published, -> { where(published: true) }

  after_initialize :default_values

  def next(path)
    phases
      .published
      .where(path_id: path.id).take
      .courses.published.order(:row).where('row > ?', self.row).first
  end

  private
    def default_values
      self.published ||= false
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

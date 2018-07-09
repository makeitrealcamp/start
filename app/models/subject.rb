# == Schema Information
#
# Table name: subjects
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

class Subject < ApplicationRecord
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
  has_many :phases, -> { distinct }, through: :course_phases
  has_many :badges, dependent: :destroy

  accepts_nested_attributes_for :course_phases, allow_destroy: true

  validates :name, presence: true

  scope :for, -> user {
    unless user.is_admin?
      published.where(id: Path.for(user).map(&:subjects).flatten.map(&:id))
    end
  }
  scope :published, -> { where(published: true) }

  after_initialize :default_values

  def next(path=nil)
    if path.nil?
      Subject.published.order(:row).where('row > ?', self.row).first
    else
      current_phase = phase_for_path(path)
      if current_phase
        current_phase.subjects.published.order(:row).where('row > ?', self.row).first
      end
    end
  end

  def phase_for_path(path)
    phases.published.where(path_id: path.id).take
  end

  def to_s
    name
  end

  def to_path
    "/subjects/#{slug}"
  end

  def to_html_link
    "<a href='#{to_path}'>#{to_s}</a>"
  end

  private
    def default_values
      self.published ||= false
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

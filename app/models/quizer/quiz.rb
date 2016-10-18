# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  name       :string
#  row        :integer
#  slug       :string
#  subject_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  published  :boolean
#
# Indexes
#
#  index_quizzes_on_subject_id  (subject_id)
#

class Quizer::Quiz < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :subject_id

  extend FriendlyId
  friendly_id :name

  belongs_to :subject
  has_many :questions
  has_many :quiz_attempts
  has_many :users, -> { uniq }, through: :quiz_attempts

  validates :name, presence: true
  validates :subject, presence: true

  after_initialize :defaults

  scope :published, -> { where(published: true) }
  scope :for, -> user { published unless user.is_admin? }

  def is_being_attempted_by_user?(user)
    user.quiz_attempts.where(quiz_id: self.id).ongoing.any?
  end

  def has_been_attempted_by_user?(user)
    user.quiz_attempts.where(quiz_id: self.id).finished.any?
  end

  def best_score_of_user(user)
    user.quiz_attempts
      .where(quiz_id: self.id)
      .finished
      .order("score DESC")
      .first
      .score
  end

  def to_s
    name
  end

  def to_path
    "#{subject.to_path}/quizzes/#{slug}"
  end

  def to_html_link
    "<a href='#{to_path}'>#{to_s}</a>"
  end

  def to_html_description
    "el quiz #{to_html_link} del tema #{subject.to_html_link}"
  end

  private

    def defaults
      self.published ||= false
      true
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

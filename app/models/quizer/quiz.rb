# == Schema Information
#
# Table name: resources
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  title         :string(100)
#  description   :string
#  row           :integer
#  type_old      :integer
#  url           :string
#  time_estimate :string(50)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  content       :text
#  slug          :string
#  published     :boolean
#  video_url     :string
#  category      :integer
#  own           :boolean
#  type          :string(100)
#
# Indexes
#
#  index_resources_on_subject_id  (subject_id)
#

class Quizer::Quiz < Resource
  has_many :questions
  has_many :quiz_attempts
  has_many :users, -> { uniq }, through: :quiz_attempts

  after_initialize :defaults

  def self.model_name
    Resource.model_name
  end

  def finished_attempts(user)
    user.quiz_attempts.where(quiz_id: self.id).finished.order('created_at DESC')
  end

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

  private

    def defaults
      self.published ||= false
      true
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

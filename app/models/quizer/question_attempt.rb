# == Schema Information
#
# Table name: question_attempts
#
#  id              :integer          not null, primary key
#  quiz_attempt_id :integer
#  question_id     :integer
#  data            :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  type            :string
#  score           :decimal(, )
#
# Indexes
#
#  index_question_attempts_on_question_id      (question_id)
#  index_question_attempts_on_quiz_attempt_id  (quiz_attempt_id)
#

class Quizer::QuestionAttempt < ActiveRecord::Base
  belongs_to :quiz_attempt
  belongs_to :question

  validates :question, presence: true
  validate :validate_data_schema

  before_save :assign_score
  after_save :update_quiz_attempt_score!

  def self.types
    [Quizer::SingleAnswerQuestionAttempt, Quizer::MultiAnswerQuestionAttempt, Quizer::OpenQuestionAttempt, Quizer::BooleanQuestionAttempt]
  end

  def form_type
    "#{type}Form".constantize
  end

  def new_form(attributes=nil)
    if attributes.nil?
      form_type.new(self)
    else
      form_type.new({ question_attempt: self }.merge(attributes))
    end
  end

  protected
    def update_quiz_attempt_score!
      self.quiz_attempt.update_quiz_attempt_score!
    end

    def assign_score
      self.score = calculate_score
    end
    # Assign a value between 0 and 1
    def calculate_score
      raise 'Abstract Method'
    end

    def data_schema
      raise 'Abstract Method'
    end

    def validate_data_schema
      unless JSON::Validator.validate(data_schema,data, insert_defaults: true)
        errors[:data] << JSON::Validator.fully_validate(data_schema, data, insert_defaults: true)
      end
    end
end

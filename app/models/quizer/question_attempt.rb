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
#
# Indexes
#
#  index_question_attempts_on_question_id      (question_id)
#  index_question_attempts_on_quiz_attempt_id  (quiz_attempt_id)
#

class Quizer::QuestionAttempt < ActiveRecord::Base
  belongs_to :quiz_attempt
  belongs_to :question

  validate :validate_data_schema

  def self.types
    [Quizer::MultiAnswerQuestionAttempt]
  end

  protected
    def data_schema
      raise 'Abstract Method'
    end

    def validate_data_schema
      unless JSON::Validator.validate(data_schema,data,insert_defaults: true)
        errors[:data] << JSON::Validator.fully_validate(data_schema,data,insert_defaults: true)
      end
    end
end

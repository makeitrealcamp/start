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

class Quizer::MultiAnswerQuestionAttempt < Quizer::QuestionAttempt

  after_initialize :defaults

  protected
    def defaults
      self.data ||= { "answers" => [] }
    end

    def data_schema
      {
        "type" => "object",
        "default" => {"answers" => []},
        "required" => ["answers"],
        "properties" => {
          "answers" => {
            "type" => "array",
            "default" => [],
            "items" => { "type" => "string" }
          }
        }
      }
    end
end

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

class Quizer::BooleanQuestionAttempt < Quizer::QuestionAttempt
  after_initialize :defaults

  def answer
    data["answer"]
  end

  def is_correct?
    answer == question.correct_answer
  end

  protected
    def defaults
      self.data ||= { "answer" => true }
    end

    def calculate_score
      is_correct? ? 1.0 : 0.0
    end

    def data_schema
      {
        "type" => "object",
        "default" => { "answer" => true },
        "required" => ["answer"],
        "properties" => {
          "answer" => {
            "type" => "boolean",
            "default" => true
          }
        }
      }
    end
end

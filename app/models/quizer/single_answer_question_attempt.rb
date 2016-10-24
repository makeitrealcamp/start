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

class Quizer::SingleAnswerQuestionAttempt < Quizer::QuestionAttempt
  after_initialize :defaults

  def answer
    data["answer"]
  end

  def answer=(sha1)
    data["answer"] = sha1
  end

  def is_correct?
    answer == SHA1.encode(question.answer)
  end

  protected
    def defaults
      self.data ||= { "answer" => "" }
    end

    def calculate_score
      is_correct? ? 1.0 : 0.0
    end

    def data_schema
      {
        "type" => "object",
        "default" => { "answer" => "" },
        "required" => ["answer"],
        "properties" => {
          "answer" => {
            "type" => "string",
            "default" => ""
          }
        }
      }
    end
end

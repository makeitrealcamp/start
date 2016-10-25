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

class Quizer::MultiAnswerQuestionAttempt < Quizer::QuestionAttempt

  after_initialize :defaults

  def answers
    data["answers"]
  end

  def is_correct?
    score == 1.0
  end

  def is_correct_answer?(answer)
    correct_answer_selected = answers.include?(SHA1.encode(answer)) && question.correct_answers.include?(answer)
    wrong_answer_avoided = !answers.include?(SHA1.encode(answer)) && question.wrong_answers.include?(answer)
    correct_answer_selected || wrong_answer_avoided
  end

  protected
    def defaults
      self.data ||= { "answers" => [] }
    end

    def calculate_score
      total = question.correct_answers.length + question.wrong_answers.length
      count = total
      count -= SHA1.encode_array(question.correct_answers).count { |a| !self.answers.include?(a) }
      count -= SHA1.encode_array(question.wrong_answers).count { |a| self.answers.include?(a) }

      total == count ? 1.0 : 0.0
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

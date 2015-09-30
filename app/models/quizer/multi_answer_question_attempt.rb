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

  def is_correct_answer?(answer_hash)
    correct_answer_selected = answers.include?(answer_hash) && question.correct_answers_hashes.include?(answer_hash)
    wrong_answer_avoided = !answers.include?(answer_hash) && question.wrong_answers_hashes.include?(answer_hash)
    correct_answer_selected || wrong_answer_avoided
  end

  protected
    def defaults
      self.data ||= { "answers" => [] }
    end

    def calculate_score
      total = question.correct_answers.length + question.wrong_answers.length
      count = total
      count -= question.correct_answers_hashes.count { |a| !answers.include?(a) }
      count -= question.wrong_answers_hashes.count { |a| answers.include?(a) }
      count/total.to_f
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

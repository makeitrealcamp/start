# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  quiz_id    :integer
#  type       :string
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#

class Quizer::MultiAnswerQuestion < Quizer::Question

  def mixed_answers
    (data["correct_answers"] + data["wrong_answers"]).shuffle
  end

  protected
    def data_schema
      {
        "type" => "object",
        "required" => ["question"],
        "properties" => {
          "question" => { "type" => "string" },
          "wrong_answers" => {
            "type" => "array",
            "default" => [],
            "items" => { "type" => "string" }
          },
          "correct_answers" => {
            "type" => "array",
            "default" => [],
            "items" => { "type" => "string" }
          }
        }
      }
    end
end

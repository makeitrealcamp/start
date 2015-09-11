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

class Quiz::MultiAnswerQuestion < Quiz::Question

  protected
    def data_schema
      {
        "type" => "object",
        "required" => ["question"],
        "properties" => {
          "question" => { "type" => "string" },
          "wrong_answers" => {
            "default" => [],
            "type" => "array",
            "items" => { "type" => "string" }
          },
          "correct_answers" => {
            "default" => [],
            "type" => "array",
            "items" => { "type" => "string" }
          }
        }
      }
    end
end

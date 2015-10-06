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
#  published  :boolean
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#

class Quizer::OpenQuestion < Quizer::Question

  after_initialize :defaults

  def correct_answer
    data["correct_answer"]
  end

  def text
    data["text"]
  end

  protected

    def defaults
      super
      self.data ||= {
        "text" => "",
        "correct_answer" => ""
      }
    end

    def data_schema
      {
        "type" => "object",
        "required" => ["text","correct_answer"],
        "properties" => {
          "text" => {
            "type" => "string",
            "default" => ""
          },
          "correct_answer" => {
            "type" => "string",
            "default" => ""
          }
        }
      }
    end
end

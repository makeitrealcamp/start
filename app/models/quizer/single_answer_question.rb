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

class Quizer::SingleAnswerQuestion < Quizer::Question
  after_initialize :defaults

  def mixed_answers
    answers = data["wrong_answers"]
    answers << data["answer"]
    answers.shuffle
  end

  def mixed_answers_with_hashes
    mixed_answers.map { |a| [a, Digest::SHA1.hexdigest(a)] }
  end

  def mixed_answers_hashes
    mixed_answers.map { |a| Digest::SHA1.hexdigest(a) }
  end

  def answer_hash
    Digest::SHA1.hexdigest(data["answer"])
  end

  def wrong_answers_hashes
    wrong_answers.map { |a| Digest::SHA1.hexdigest(a) }
  end

  def text=(text)
    data["text"] = text
  end

  def text
    data["text"]
  end

  def answer=(answer)
    data["answer"] = answer
  end

  def answer
    data["answer"]
  end

  def wrong_answers=(wrong_answers)
    data["wrong_answers"] = wrong_answers
  end

  def wrong_answers
    data["wrong_answers"]
  end

  protected
    def defaults
      super
      self.data ||= {
        "text" => "",
        "wrong_answers" => [],
        "answer" => ""
      }
    end

    def data_schema
      {
        "type" => "object",
        "required" => ["text", "answer"],
        "properties" => {
          "text" => { "type" => "string" },
          "wrong_answers" => {
            "type" => "array",
            "default" => [],
            "items" => { "type" => "string" }
          },
          "answer" => {
            "type" => "string"
          }
        }
      }
    end
end

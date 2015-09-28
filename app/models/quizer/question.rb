
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

class Quizer::Question < ActiveRecord::Base
  belongs_to :quiz
  validate :validate_data_schema

  def self.types
    [Quizer::MultiAnswerQuestion]
  end

  def attempt_type
    unless Quizer::Question.types.map(&:to_s).include? self.type
      raise "Invalid Question Type"
    end
    (type+'Attempt').constantize
  end

  def create_attempt!(attributes)
    attempt_type.create!({question: self}.merge(attributes))
  end

  protected
    def data_schema
      raise 'Abstract Method'
    end

    def validate_data_schema
      unless JSON::Validator.validate(data_schema,data,insert_defaults: true)
        errors[:data] << JSON::Validator.fully_validate(data_schema,self.data,insert_defaults: true)
      end
    end

end

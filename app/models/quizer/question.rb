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

class Quizer::Question < ActiveRecord::Base
  belongs_to :quiz

  validate :validate_data_schema

  after_initialize :defaults

  scope :published, -> { where(published: true) }

  def self.types
    [Quizer::SingleAnswerQuestion, Quizer::MultiAnswerQuestion, Quizer::OpenQuestion]
  end

  def attempt_type
    (type+'Attempt').constantize
  end

  def form_type
    (type+'Form').constantize
  end

  def create_attempt!(attributes)
    attempt_type.create!({question: self}.merge(attributes))
  end

  def new_form(attributes=nil)
    if attributes.nil?
      form_type.new(self)
    else
      form_type.new({question: self}.merge(attributes))
    end
  end

  # Method used to display the question or a summary of the question
  def text
    raise 'Abstract Method'
  end

  protected

    def defaults
      self.published ||= false
      true
    end

    def data_schema
      raise 'Abstract Method'
    end

    def validate_data_schema
      unless JSON::Validator.validate(data_schema,data,insert_defaults: true)
        errors[:data] << JSON::Validator.fully_validate(data_schema,self.data,insert_defaults: true)
      end
    end

end

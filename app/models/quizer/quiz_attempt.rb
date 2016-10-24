# == Schema Information
#
# Table name: quiz_attempts
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  quiz_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  status           :integer
#  score            :decimal(, )
#  current_question :integer          default(0)
#
# Indexes
#
#  index_quiz_attempts_on_quiz_id  (quiz_id)
#  index_quiz_attempts_on_user_id  (user_id)
#

class Quizer::QuizAttempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :quiz
  has_many :question_attempts
  has_many :questions, through: :question_attempts

  validate :validate_unique_attempt_per_user

  enum status: [:ongoing, :finished, :cancelled]

  after_initialize :defaults
  after_create :assign_questions
  after_create :log_start_activity
  after_save :log_end_activity

  def update_quiz_attempt_score!
    self.score = question_attempts.sum(:score) / questions.count.to_f
    save!
  end

  def current_question_attempt
    self.question_attempts[self.current_question]
  end

  def next_question!
    question_attempt = self.question_attempts[self.current_question]
    self.increment!(:current_question)
    question_attempt
  end

  def is_last_question?
    current_question == (self.question_attempts.count - 1)
  end

  private
    def defaults
      self.status ||= Quizer::QuizAttempt.statuses[:ongoing]
      self.score ||= 0
    end

    def validate_unique_attempt_per_user
      if user && user.quiz_attempts.ongoing.where.not(id: id).exists?(quiz_id: quiz_id)
        errors[:user] << "should finish existing quiz attempt"
      end
    end

    def assign_questions
      questions = self.quiz.questions.published.shuffle
      questions.each do |question|
        question.create_attempt!(quiz_attempt: self)
      end
    end

    def log_start_activity
      description = "Inició #{quiz.to_html_description}"
      ActivityLog.create(name: "started-quiz", user: user, activity: self, description: description)
    end

    def log_end_activity
      if finished?
        description = "Finalizó #{quiz.to_html_description} con un puntaje de #{score}"
        ActivityLog.create(name: "finished-quiz", user: user, activity: self, description: description)
      end
    end
end

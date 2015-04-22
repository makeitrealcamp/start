# == Schema Information
#
# Table name: challenges
#
#  id                  :integer          not null, primary key
#  course_id           :integer
#  name                :string(100)
#  instructions        :text
#  evaluation          :text
#  row                 :integer
#  published           :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  slug                :string
#  evaluation_strategy :integer
#  solution_video_url  :string
#  solution_text       :text
#

class Challenge < ActiveRecord::Base
  has_paper_trail on: [:update, :destroy]

  include RankedModel
  ranks :row, with_same: :course_id

  extend FriendlyId
  friendly_id :name, use: :slugged

  enum evaluation_strategy: [:ruby_embedded, :phantomjs_embedded, :ruby_git, :rails_git]

  belongs_to :course
  has_many :documents, as: :folder
  has_many :comments, as: :commentable

  validates :name, presence: true
  validates :instructions, presence: true

  scope :for, -> user { published unless user.is_admin? }
  scope :published, -> { where(published: true) }
  default_scope { rank(:row) }

  after_initialize :default_values

  accepts_nested_attributes_for :documents, allow_destroy: true

  def preview?
    !self.ruby_git?
  end

  def next
    next_challenge = self.course.challenges.published.where('row > ?', self.row).first
  end

  def last?
    self.next.nil?
  end

  private
    def default_values
      self.published ||= false
      self.evaluation ||= "def evaluate(files)\n  \nend"
      self.evaluation_strategy ||= :ruby_embedded
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

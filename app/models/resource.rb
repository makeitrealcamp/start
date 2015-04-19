# == Schema Information
#
# Table name: resources
#
#  id            :integer          not null, primary key
#  course_id     :integer
#  title         :string(100)
#  description   :string
#  row           :integer
#  type          :integer
#  url           :string
#  time_estimate :string(50)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  content       :text
#  slug          :string
#  published     :boolean
#

class Resource < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :course_id

  extend FriendlyId
  friendly_id :title, use: :slugged

  self.inheritance_column = nil

  enum type: [:url, :markdown]

  belongs_to :course
  has_and_belongs_to_many :users

  validates :course, :title, :description, presence: :true
  validates :url, presence: true, format: { with: URI.regexp }, if: :url?
  validates :content, presence: true, if: :markdown?

  scope :for, -> user { published unless user.is_admin? }
  scope :published, -> { where(published: true) }
  default_scope { rank(:row) }

  after_initialize :default_values

  def next
    self.course.resources.published.where('row > ?', self.row).first
  end

  def last?
    self.next.nil?
  end

  private
    def default_values
      self.published ||= false
      self.type ||= :url
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

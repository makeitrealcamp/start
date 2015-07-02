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
#  video_url     :string
#  category      :integer
#  own           :boolean
#
# Indexes
#
#  index_resources_on_course_id  (course_id)
#

class Resource < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :course_id

  extend FriendlyId
  friendly_id :title

  self.inheritance_column = nil

  enum type: [:url, :markdown, :course]
  enum category: [:blog_post,:video_tutorial,:reading,:game,:tutorial,:documentation]

  belongs_to :course
  has_many :sections, dependent: :delete_all
  has_many :comments, as: :commentable # TODO: change to reviews
  has_many :resource_completions, dependent: :delete_all


  accepts_nested_attributes_for :sections, allow_destroy: true

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

  def self_completable?
    ["markdown","url"].include? self.type
  end

  def to_s
    title
  end

  private
    def default_values
      self.published ||= false
      self.type ||= :url
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

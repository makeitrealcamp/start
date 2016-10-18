# == Schema Information
#
# Table name: resources
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  title         :string(100)
#  description   :string
#  row           :integer
#  type_old      :integer
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
#  type          :string(100)
#
# Indexes
#
#  index_resources_on_subject_id  (subject_id)
#

class Resource < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :subject_id

  extend FriendlyId
  friendly_id :title

  enum category: [:blog_post, :video_tutorial, :reading, :game, :tutorial, :documentation]

  belongs_to :subject
  has_many :comments, as: :commentable # TODO: change to reviews
  has_many :resource_completions, dependent: :delete_all

  validates :subject, :title, :description, presence: :true

  scope :for, -> user { published unless user.is_admin? }
  scope :published, -> { where(published: true) }
  default_scope { rank(:row) }

  after_initialize :default_values

  def next
    self.subject.resources.published.where('row > ?', self.row).first
  end

  def last?
    self.next.nil?
  end

  def self_completable?
    url? || markdown?
  end

  def type_name
    return "url" if url?
    return "markdown" if markdown?
    return "course" if course?
    return "quiz" if quiz?
  end

  def url?
    self.type == "ExternalUrl"
  end

  def markdown?
    self.type == "MarkdownDocument"
  end

  def course?
    self.type == "Course"
  end

  def quiz?
    self.type == "Quizer::Quiz"
  end

  def to_s
    title
  end

  def to_path
    "#{subject.to_path}/resources/#{slug}"
  end

  def to_html_link
    "<a href='#{to_path}'>#{title}</a>"
  end

  def to_html_description
    "#{to_html_link} del tema #{subject.to_html_link}"
  end

  private
    def default_values
      self.published ||= false
      self.type ||= "ExternalUrl"
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

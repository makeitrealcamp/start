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
#

class Resource < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :course_id

  self.inheritance_column = nil

  enum type: [:url, :markdown]

  belongs_to :course
  has_and_belongs_to_many :users

  validates :course, :title, :description, presence: :true
  validates :url, presence: true, format: { with: URI.regexp }, if: :is_url
  validates :content, presence: true, if: :is_markdown

  default_scope { rank(:row) }

  after_initialize :default_values

  def is_url
    self.type == "url"
  end

  def is_markdown
    self.type == "markdown"
  end

  private
    def default_values
      self.type ||= :url
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

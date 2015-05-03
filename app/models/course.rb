# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string(50)
#  row           :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  time_estimate :string(50)
#  excerpt       :string
#  description   :string
#  slug          :string
#  published     :boolean
#

class Course < ActiveRecord::Base
  include RankedModel
  ranks :row

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :resources
  has_many :challenges

  validates :name, presence: true
  scope :for, -> user { published unless user.is_admin? }
  scope :published, -> { where(published: true) }
  default_scope { rank(:row) }

  after_initialize :default_values

  def next
    Course.published.where('row > ?', self.row).first
  end

  private
    def default_values
      self.published ||= false
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

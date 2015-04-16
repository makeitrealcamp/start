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
#  visibility    :integer
#

class Course < ActiveRecord::Base
  include RankedModel
  ranks :row

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :resources
  has_many :challenges

  validates :name, presence: true

  scope :published, -> { where(published: true) }
  default_scope { rank(:row) }

  enum visibility: [:everyone, :paid_students]

  after_initialize :default_values

   def self.for(user)
    if user.free_account?
      everyone.published
    elsif user.paid_account?
      published
    elsif user.admin_account?
      all
    end
  end

  private
    def default_values
      self.published ||= false
      self.visibility ||= :everyone
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

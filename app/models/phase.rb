# == Schema Information
#
# Table name: phases
#
#  id          :integer          not null, primary key
#  number      :integer
#  name        :string
#  description :text
#  slug        :string
#  row         :integer
#  published   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Phase < ActiveRecord::Base
  include RankedModel
  ranks :row

  extend FriendlyId
  friendly_id :name

  has_many :courses

  after_initialize :default_values

  default_scope { rank(:row) }
  scope :for, -> user { published unless user.is_admin? }
  scope :published, -> { where(published: true) }



  private
    def default_values
      self.published ||= false
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end
end

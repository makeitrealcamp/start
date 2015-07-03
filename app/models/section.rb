# == Schema Information
#
# Table name: sections
#
#  id          :integer          not null, primary key
#  resource_id :integer
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  row         :integer
#
# Indexes
#
#  index_sections_on_resource_id  (resource_id)
#

class Section < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :resource_id

  belongs_to :resource
  has_many :lessons, dependent: :delete_all
  accepts_nested_attributes_for :lessons, allow_destroy: true

  validates :title, presence: true

  default_scope { rank(:row) }

  alias_method :course, :resource
  alias_method :course=, :resource=



  def next(user)
    self.resource.sections.where('row > ?', self.row).first
  end
end

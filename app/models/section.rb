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

class Section < ApplicationRecord
  include RankedModel
  ranks :row, with_same: :resource_id

  belongs_to :resource, class_name: "Course"
  has_many :lessons, dependent: :delete_all

  validates :title, presence: true

  default_scope { rank(:row) }
  delegate :course, to: :resource

  alias_method :course, :resource
  alias_method :course=, :resource=

  def next(user)
    self.resource.sections.where('row > ?', self.row).first
  end

  def to_path
    "#{resource.to_path}/sections/#{id}"
  end
end

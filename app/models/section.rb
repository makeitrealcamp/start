# == Schema Information
#
# Table name: sections
#
#  id          :integer          not null, primary key
#  resource_id :integer
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Section < ActiveRecord::Base
  belongs_to :resource
  has_many :lessons, dependent: :delete_all
  accepts_nested_attributes_for :lessons, allow_destroy: true

  alias_method :course, :resource
  alias_method :course=, :resource=
end

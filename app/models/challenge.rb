# == Schema Information
#
# Table name: challenges
#
#  id           :integer          not null, primary key
#  course_id    :integer
#  name         :string(100)
#  instructions :text
#  evaluation   :text
#  row          :integer
#  published    :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Challenge < ActiveRecord::Base
  has_paper_trail on: [:update, :destroy]

  include RankedModel
  ranks :row, with_same: :course_id

  belongs_to :course
  has_many :documents, as: :folder

  scope :for, -> user { published unless user.is_admin? } 
  scope :published, -> { where(published: true) }
  default_scope { rank(:row) }
end

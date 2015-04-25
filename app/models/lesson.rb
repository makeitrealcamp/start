# == Schema Information
#
# Table name: lessons
#
#  id          :integer          not null, primary key
#  section_id  :integer
#  name        :string
#  video_url   :string
#  description :text
#  row         :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Lesson < ActiveRecord::Base
  belongs_to :section
  has_many :comments, as: :commentable
end

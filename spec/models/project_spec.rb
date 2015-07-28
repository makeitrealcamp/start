# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  course_id             :integer
#  name                  :string
#  explanation_text      :text
#  explanation_video_url :string
#  published             :boolean
#  row                   :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  difficulty_bonus      :integer          default(0)
#
# Indexes
#
#  index_projects_on_course_id  (course_id)
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

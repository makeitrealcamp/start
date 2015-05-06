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
#

class Project < ActiveRecord::Base
  belongs_to :course

  after_initialize :defaults
  scope :published, -> { where(published: true) }

  protected

  def defaults
    self.published ||= false
    true
  end
end

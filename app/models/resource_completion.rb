# == Schema Information
#
# Table name: resources_users
#
#  user_id     :integer          not null
#  resource_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class ResourceCompletion < ActiveRecord::Base
  self.table_name = "resources_users"

  belongs_to :user
  belongs_to :resource

end

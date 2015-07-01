# == Schema Information
#
# Table name: resources_users
#
#  user_id     :integer          not null
#  resource_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_resources_users_on_resource_id_and_user_id  (resource_id,user_id) UNIQUE
#

class ResourceCompletion < ActiveRecord::Base
  self.table_name = "resources_users"

  belongs_to :user
  belongs_to :resource

end

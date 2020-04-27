# == Schema Information
#
# Table name: resources_users
#
#  resource_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_resources_users_on_resource_id_and_user_id  (resource_id,user_id) UNIQUE
#

class ResourceCompletion < ApplicationRecord
  self.table_name = "resources_users"

  belongs_to :user
  belongs_to :resource

  after_create :log_activity

  def log_activity
    description = "Completó el recurso #{resource.to_html_description}"
    ActivityLog.create(name: "completed-resource", user: user, activity: resource, description: description)
  end
end

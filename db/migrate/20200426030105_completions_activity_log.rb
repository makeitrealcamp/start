class CompletionsActivityLog < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        ResourceCompletion.all.each do |completion|
          resource = completion.resource

          description = "Completó el recurso #{resource.to_html_description}"
          ActivityLog.create(name: "completed-resource", user: completion.user, activity: resource, description: description, created_at: completion.created_at)
        end
      end
    end
  end
end

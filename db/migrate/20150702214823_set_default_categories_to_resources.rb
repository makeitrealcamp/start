class SetDefaultCategoriesToResources < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        Resource.where(type: Resource.types[:course]).update_all(
          category: Resource.categories[:video_tutorial],
          own: true
        )

        Resource.where(type: Resource.types[:markdown]).update_all(
          category: Resource.categories[:reading],
          own: true
        )
      end

    end
  end
end

class AddRowToSection < ActiveRecord::Migration
  def change
    add_column :sections, :row, :integer

    reversible do |dir|
      dir.up do
        Resource.course.each_with_index do |resource, index|
          resource.sections.each_with_index do |section, j|
            section.update(row: j)
          end
        end
      end
    end
  end
end

class AddCohortToTopApplicants < ActiveRecord::Migration[5.2]
  def change
    add_reference :applicants, :cohort, index: true, foreign_key: { on_delete: :cascade }

    reversible do |dir|
      dir.up do
        cohort = TopCohort.create!(name: "Convocatorias Pasadas")
        TopApplicant.update_all(cohort_id: cohort.id)
      end
    end
  end
end

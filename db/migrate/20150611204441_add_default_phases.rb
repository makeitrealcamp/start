class AddDefaultPhases < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        phase_1 = Phase.create(
          name: "Programador Aprendiz",
          description: "Aprende los conceptos básicos del desarrollo web.",
          row_position: 0
        )
        phase_2 = Phase.create(
          name: "Desarrollador Web",
          description: "Aprende a crear aplicaciones web con Ruby on Rails.",
          row_position: 1
        )
        phase_3 = Phase.create(
          name: "Desarrollador Web Profesional",
          description: "Conviértete en un desarrollador web profesional capaz de implementar soluciones complejas.",
          row_position: 2
        )
        Course.update_all(phase_id: phase_1.id)
      end

      dir.down do
        phases = Phase.where(name: ["Programador Aprendiz","Desarrollador Web","Desarrollador Web Profesional"])
        Course.where(phase_id: phases.pluck(:id)).update_all(phase_id: nil)
        phases.destroy_all
      end

    end
  end
end

class InsertDefaultPaths < ActiveRecord::Migration
  def change
    full_stack = Path.create(name: "Full-Stack", description: "Conviértete en un desarrollador Full-Stack.",published: true)
    front_end = Path.create(name: "Front-End", description: "Conviértete en un desarrollador Front-End.",published: false)
    Phase.update_all(path_id: full_stack.reload.id)
  end
end

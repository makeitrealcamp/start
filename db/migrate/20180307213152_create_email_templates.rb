class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.string :title
      t.string :subject
      t.text :body
      t.timestamps null: false
    end
  end
end

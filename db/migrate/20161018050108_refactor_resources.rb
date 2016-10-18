class RefactorResources < ActiveRecord::Migration
  def change
    rename_column :resources, :type, :type_old
    add_column :resources, :type, :string, limit: 100

    reversible do |dir|
      dir.up do
        Resource.all.each do |resource|
          type = if resource.type_old == 0
            "ExternalUrl"
          elsif resource.type_old == 1
            "MarkdownDocument"
          elsif resource.type_old == 2
            "Course"
          elsif resource.type_old == 3
            "Quizer::Quiz"
          end
          resource.update!(type: type)
        end
      end

      dir.down do
        Resource.all.each do |resource|
          type = if resource.type == "ExternalUrl"
            0
          elsif resource.type == "MarkdownDocument"
            1
          elsif resource.type == "Course"
            2
          elsif resource.type == "Quizer::Quiz"
            3
          end
          resource.update!(type_old: type)
        end
      end
    end

    remove_column :resources, :type_old, :integer

    reversible do |dir|
      dir.up do
        quizzes = ActiveRecord::Base.connection.exec_query('SELECT * FROM quizzes')

        remove_foreign_key :questions, :quizzes
        remove_foreign_key :quiz_attempts, :quizzes

        quizzes.each do |quiz|
          resource = Resource.create!(subject_id: quiz['subject_id'], title: quiz['name'],
            description: quiz['name'], row_position: :last, type: "Quizer::Quiz",
            published: quiz['published'], own: true, slug: quiz['slug'],
            created_at: quiz['created_at'], updated_at: quiz['updated_at'])

          Quizer::Question.where(quiz_id: quiz['id']).update_all(quiz_id: resource.id)
          Quizer::QuizAttempt.where(quiz_id: quiz['id']).update_all(quiz_id: resource.id)
        end

        add_foreign_key :questions, :resources, column: :quiz_id
        add_foreign_key :quiz_attempts, :resources, column: :quiz_id
      end

      dir.down do
        remove_foreign_key :questions, column: :quiz_id
        remove_foreign_key :quiz_attempts, column: :quiz_id

        Resource.where(type: "Quizer::Quiz").each do |resource|
          id = ActiveRecord::Base.connection.insert_sql("INSERT INTO quizzes (name, row, slug, subject_id, created_at, updated_at, published) VALUES ('#{resource.title}', 0, '#{resource.slug}', #{resource.subject_id}, '#{resource.created_at}', '#{resource.updated_at}', #{resource.published})")

          Quizer::Question.where(quiz_id: resource.id).update_all(quiz_id: id)
          Quizer::QuizAttempt.where(quiz_id: resource.id).update_all(quiz_id: id)
        end

        add_foreign_key :questions, :quizzes
        add_foreign_key :quiz_attempts, :quizzes
      end
    end

    drop_table :quizzes do |t|
      t.string :name
      t.integer :row
      t.string :slug
      t.references :subject, index: true
      t.boolean :published

      t.timestamps null: false
    end
  end
end

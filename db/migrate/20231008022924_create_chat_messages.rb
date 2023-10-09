class CreateChatMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_messages do |t|
      t.references :chat, null: false, foreign_key: { on_delete: :cascade }
      t.text :request
      t.text :response

      t.timestamps
    end
  end
end

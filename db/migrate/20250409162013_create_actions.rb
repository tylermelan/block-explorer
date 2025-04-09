class CreateActions < ActiveRecord::Migration[8.0]
  def change
    create_table :actions do |t|
      t.string :action_type, null: false
      t.jsonb :data, default: {}
      t.references :block_transaction, null: false, foreign_key: true

      t.timestamps
    end
    add_index :actions, :action_type
  end
end

class CreateBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :blocks do |t|
      t.integer :height, null: false
      t.string :block_hash, null: false

      t.timestamps
    end
    add_index :blocks, :height, unique: true
    add_index :blocks, :block_hash, unique: true
  end
end

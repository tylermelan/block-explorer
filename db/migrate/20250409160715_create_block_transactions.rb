class CreateBlockTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :block_transactions do |t|
      t.datetime :time
      t.string :txn_hash, null: false
      t.string :sender
      t.string :receiver
      t.jsonb :data, default: {}
      t.references :block, null: false, foreign_key: true

      t.timestamps
    end
    add_index :block_transactions, :txn_hash, unique: true
  end
end

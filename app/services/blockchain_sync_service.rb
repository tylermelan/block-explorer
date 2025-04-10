class BlockchainSyncService
  def initialize(blockchain_transactions)
    @blockchain_transactions = blockchain_transactions
  end

  def sync
    build_model_maps
    build_insert_arrays
    insert_blocks
    insert_block_transactions
    insert_actions
  end

  private

  def build_model_maps
    block_hashes = []
    txn_hashes = []
    @blockchain_transactions.each do |blockchain_transaction|
      blockchain_transaction => { block_hash:, hash: txn_hash }
      block_hashes.push(block_hash)
      txn_hashes.push(txn_hash)
    end

    @blocks_map = Block.where(block_hash: block_hashes).pluck(:block_hash, :id).to_h
    @block_transactions_map = BlockTransaction.where(txn_hash: txn_hashes).pluck(:txn_hash, :id).to_h
  end

  def build_insert_arrays
    @blocks_to_insert = []
    @block_transactions_to_insert = []
    @actions_to_insert = []

    @blockchain_transactions.each do |blockchain_transaction|
      blockchain_transaction => {height:, block_hash:, **block_transaction_attributes}
      if @blocks_map[block_hash].nil?
        @blocks_to_insert.push({ height:, block_hash: })
      end

      block_transaction_attributes => {hash: txn_hash, time:, sender:, receiver:, actions:, **data}
      if @block_transactions_map[txn_hash].nil?
        @block_transactions_to_insert.push({ txn_hash:, time:, sender:, receiver:, data:, block_id: block_hash })

        actions.each do |action_data|
          action_data => {type: action_type, data:}
          @actions_to_insert.push({ action_type:, data:, block_transaction_id: txn_hash })
        end
      end
    end
  end

  def insert_blocks
    blocks_result = Block.insert_all(@blocks_to_insert, returning: %w[ block_hash id ])
    @blocks_map = @blocks_map.merge(blocks_result.rows.to_h)

    @block_transactions_to_insert.each do |transaction_block|
      block_hash = transaction_block[:block_id]
      transaction_block[:block_id] = @blocks_map[block_hash]
    end
  end

  def insert_block_transactions
    block_transactions_result = BlockTransaction.insert_all(@block_transactions_to_insert, returning: %w[ txn_hash id ])
    @block_transactions_map = @block_transactions_map.merge(block_transactions_result.rows.to_h)

    @actions_to_insert.each do |action|
      txn_hash = action[:block_transaction_id]
      action[:block_transaction_id] = @block_transactions_map[txn_hash]
    end
  end

  def insert_actions
    Action.insert_all(@actions_to_insert)
  end
end

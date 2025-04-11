class BlockTransactionsController < ApplicationController
  def index
    @block_transactions = BlockTransaction
                            .transfers
                            .select(:sender, :receiver, actions: { data: :action_data })
                            .order(time: :desc)
  end
end

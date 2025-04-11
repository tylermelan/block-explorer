class BlockchainSyncJob < ApplicationJob
  DELAY = 1.minute
  queue_as :default

  after_perform do
    self.class.set(wait: DELAY).perform_later
  end

  def perform
    blockchain_transactions = BlockchainApiClient.fetch_transactions
    blockchain_sync_service = BlockchainSyncService.new(blockchain_transactions)
    blockchain_sync_service.sync
  rescue => error
    Rails.logger.error "BlockchainSyncJob error: #{error.message}"
  end
end

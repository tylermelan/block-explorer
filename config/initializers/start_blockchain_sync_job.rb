Rails.application.config.after_initialize do
  if defined?(Rails::Server)
    BlockchainSyncJob.perform_later
  end
end

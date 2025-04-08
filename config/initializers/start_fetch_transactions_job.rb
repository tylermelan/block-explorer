Rails.application.config.after_initialize do
  if defined?(Rails::Server)
    FetchTransactionsJob.perform_later
  end
end

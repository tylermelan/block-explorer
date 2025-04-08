class FetchTransactionsJob < ApplicationJob
  DELAY = 1.minute
  queue_as :default

  after_perform do
    self.class.set(wait: DELAY).perform_later
  end

  def perform
    puts "Fetching transactions..."
    raise "Nooooooo"
  rescue
    puts "Error fetching transactions."
  end
end

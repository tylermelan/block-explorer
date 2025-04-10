require "net/http"

class BlockchainApiClient
  TRANSACTIONS_URI = URI("https://4816b0d3-d97d-47c4-a02c-298a5081c0f9.mock.pstmn.io/near/transactions?api_key=#{Rails.application.credentials.blockchain_api_key}")

  def self.fetch_transactions
    response = Net::HTTP.get(TRANSACTIONS_URI)
    JSON.parse(response, symbolize_names: true)
  end
end

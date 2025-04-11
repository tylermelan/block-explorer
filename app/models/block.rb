class Block < ApplicationRecord
  has_many :block_transactions, dependent: :destroy
end

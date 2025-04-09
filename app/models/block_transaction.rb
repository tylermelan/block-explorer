class BlockTransaction < ApplicationRecord
  belongs_to :block
  has_many :actions
end

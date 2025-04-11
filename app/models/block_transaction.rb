class BlockTransaction < ApplicationRecord
  belongs_to :block
  has_many :actions, dependent: :destroy

  scope :transfers, -> { joins(:actions).where(actions: { action_type: "Transfer" }) }
end

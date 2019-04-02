class Transaction < ApplicationRecord
  belongs_to :account

  TRANSACTION_TYPES = %w[deposit withdraw transfer]
  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES}

  before_validation :generate_transaction_number

  def generate_transaction_number
    if self.new_record?
      self.transaction_number = SecureRandom.uuid
    end
  end
end

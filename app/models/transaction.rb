class Transaction < ApplicationRecord
  belongs_to :account

  TRANSACTION_TYPES = %w[deposit withdraw transfer]
  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES}
  scope :transactions_for_account, ->(account_id) { where("account_id = ? or recipient_account_number = ?", account_id, account_id)}

  before_validation :generate_transaction_number

  def generate_transaction_number
    self.transaction_number = SecureRandom.uuid if self.new_record?
  end
end

module Accounts
  class ValidateNewTransaction
    def initialize(amount: , transaction_type: , account_id:, recipient_account_number: )
      @amount = amount.try(:to_f) 
      @transaction_type = transaction_type
      @account_id = account_id
      @account = Account.find(@account_id)
      @recipient_account_number = recipient_account_number
    end

    def execute!
      @errors = []
      validate_existence_of_account_by_number!(@recipient_account_number) if @transaction_type == "transfer"
      validate_existence_of_account!
      validate_sender_account_recipient_account_is_different! if @transaction_type == "transfer"
      validate_amount_greater_than_zero!(@amount)
      validate_withdrawal!(@account, @amount) if ["withdraw", "transfer"].include? @transaction_type
      @errors
    end

    private

    def validate_amount_greater_than_zero!(amount)
      @errors << "Please Specify amount" if amount <= 0.00
    end

    def validate_withdrawal!(account, amount)
      @errors << "Not enough money" if account.current_balance - amount < 0.00
    end

    def validate_existence_of_account!
      @errors << "Account not found" if @account.blank?
    end

    def validate_existence_of_account_by_number!(account_number)
      account = Account.find_by_account_number(account_number)
      @errors << "Recipient Account not found" if account.nil?
    end

    def validate_sender_account_recipient_account_is_different!
      @errors << "Recipient Account and Sender account should be different" if @account.account_number == @recipient_account_number.to_i
    end
  end
end
module Accounts
  class PerformTransaction
    def initialize(amount: , transaction_type: , account_id: ,  recipient_account_id: )
      @amount = amount.to_f
      @transaction_type = transaction_type
      @account_id = account_id
      @recipient_account_id = recipient_account_id
    end

    def execute!()
      @account = Account.find(@account_id)
      @recipient_account = Account.find_by_account_number(@recipient_account_id) if @transaction_type != "transfer"
      ActiveRecord::Base.transaction do
        Transaction.create!(
          account_id: @account.id,
          amount: @amount,
          transaction_type: @transaction_type,
          recipient_account_number: @recipient_account.present? ? @recipient_account.id : @recipient_account_id
        )
        case @transaction_type
        when "withdraw"
          @account.update!(current_balance: @account.current_balance.to_f - @amount)
        when "deposit"
          @account.update!(current_balance: @account.current_balance.to_f + @amount)
        else
          @account.update!(current_balance: @account.current_balance.to_f - @amount)
          @recipient_account.update!(current_balance: @recipient_account.current_balance.to_f + @amount)
        end
      end
      @account
    end
  end
end
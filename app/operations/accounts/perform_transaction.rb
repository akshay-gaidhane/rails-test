module Accounts
  class PerformTransaction
    def initialize(amount: , transaction_type: , account_id: ,  recipient_account_id: )
        @amount = amount.to_f
        @transaction_type = transaction_type
        @account_id = account_id
        @account = Account.where(id: @account_id).first
        @recipient_account_id = recipient_account_id
        @recipient_account = Account.where(id: @recipient_account_id).first if @recipient_account_id.present? && @recipient_account_id != 0
    end

    def execute!()
        ActiveRecord::Base.transaction do
            Transaction.create!(
                account_id: @account.id,
                amount: @amount,
                transaction_type: @transaction_type,
                recipient_account_number: @recipient_account_id
            )
            if @transaction_type == "withdraw"
              @account.update!(current_balance: @account.current_balance.to_f - @amount)
            elsif @transaction_type == "deposit" 
              @account.update!(current_balance: @account.current_balance.to_f + @amount)
            else
              @account.update!(current_balance: @account.current_balance.to_f - @amount)
              @recipient_account.update!(current_balance: @recipient_account.current_balance.to_f + @amount)
            end
        end
        @account
    end

    private

  end
end
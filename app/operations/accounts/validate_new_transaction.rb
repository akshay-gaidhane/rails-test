module Accounts
    class ValidateNewTransaction
        def initialize(amount: , transaction_type: , account_id: )
            @amount = amount.try(:to_f) 
            @transaction_type = transaction_type
            @account_id = account_id
            @account = Account.where(id: @account_id).first
            @errors = []
        end

        def execute!
            validate_existence_of_account!
            validate_amount_greater_than_zero!

            if ["withdraw", "transfer"].include? @transaction_type  and @account.present?
                validate_withdrawal!
            end
            @errors
        end

        private

        def validate_amount_greater_than_zero!
            if @amount <= 0.00
                @errors << "Please Specify amount"
            end
        end

        def validate_withdrawal!
            if @account.current_balance - @amount < 0.00
                @errors << "Not enough money"
            end
        end

        def validate_existence_of_account!
            if @account.blank?
                @errors << "Account not found"
            end

        end
    end
end
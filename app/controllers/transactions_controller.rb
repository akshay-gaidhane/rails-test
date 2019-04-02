class TransactionsController < ApplicationController
  def new
    @account = Account.find params[:account_id]
    @transaction = Transaction.new
  end

  def transfer
    @account = Account.find params[:account_id]
    @transaction = Transaction.new
    @accounts = Account.all.select([:id, :account_number])
  end

  def create
    @transaction = Transaction.new
    amount = transaction_params[:amount]
    transaction_type = transaction_params[:transaction_type]
    @account = Account.find params[:account_id]
    @accounts = Account.all.select([:id, :account_number])
    recipient_account = transaction_params[:recipient_account_number].present? ? transaction_params[:recipient_account_number] : 0

    @errors = ::Accounts::ValidateNewTransaction.new(
        amount: amount,
        transaction_type: transaction_type,
        account_id: params[:account_id]
    ).execute!

    if @errors.size > 0
      if recipient_account != "-"
        render 'transfer', { errors: @errors }
      else
        render 'new', { errors: @errors }
      end
    else
        account = ::Accounts::PerformTransaction.new(
            amount: amount,
            transaction_type: transaction_type,
            account_id: params[:account_id],
            recipient_account_id: recipient_account
        ).execute!

        respond_to do |format|
          format.html { redirect_to root_url }
        end
    end
  end

  def view_transactions
    @account = Account.find params[:account_id]
    @all_transactions_for_account = Transaction.where("account_id = ? or recipient_account_number = ?", @account.id, @account.id) 
  end

  private
    def transaction_params
      params.require(:transaction).permit(:transaction_type, :amount, :recipient_account_number)
    end

end

class TransactionsController < ApplicationController
  before_action :authenticate_user!, :set_account

  def new
    @transaction = Transaction.new
  end

  def transfer
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new
    amount = transaction_params[:amount]
    transaction_type = transaction_params[:transaction_type]
    recipient_account = transaction_type == "transfer" ? transaction_params[:recipient_account_number] : 0

    @errors = ::Accounts::ValidateNewTransaction.new(
        amount: amount,
        transaction_type: transaction_type,
        account_id: params[:account_id],
        recipient_account_number: recipient_account
    ).execute!

    if @errors.size > 0
      render (transaction_type == "transfer" ? 'transfer' : 'new'), { errors: @errors }
    else
      account = ::Accounts::PerformTransaction.new(
          amount: amount,
          transaction_type: transaction_type,
          account_id: params[:account_id],
          recipient_account_id: recipient_account
      ).execute!

      redirect_to root_url
    end
  end

  def view_transactions
    @all_transactions_for_account = Transaction.transactions_for_account(@account.id)
  end

  private
    def transaction_params
      params.require(:transaction).permit(:transaction_type, :amount, :recipient_account_number)
    end

    def set_account
      @account = Account.find params[:account_id]
    end
end

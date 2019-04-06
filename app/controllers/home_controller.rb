class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @account = current_user.accounts.first
    @transactions = Transaction.transactions_for_account(@account.id).limit(10) if @account.transactions
  end
end

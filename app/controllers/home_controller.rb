class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @account = current_user.accounts.first
    @transactions = @account.transactions.limit(10) if @account && @account.transactions.present?
  end
end

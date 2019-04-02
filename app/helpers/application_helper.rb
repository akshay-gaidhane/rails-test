module ApplicationHelper
  def account_number(id)
    return Account.find(id).account_number
  end
end

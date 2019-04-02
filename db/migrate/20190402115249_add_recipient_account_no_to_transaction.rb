class AddRecipientAccountNoToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :recipient_account_number, :integer, :limit => 8
  end
end

class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.integer :account_number, :limit => 8
      t.decimal :current_balance
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

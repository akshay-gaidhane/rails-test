class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :type
      t.decimal :amount
      t.integer :account_id
      t.string :transaction_number

      t.timestamps
    end
  end
end

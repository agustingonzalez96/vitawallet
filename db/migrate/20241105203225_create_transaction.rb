class CreateTransaction < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :transaction_type
      t.decimal :amount_usd
      t.decimal :amount_btc
      t.decimal :balance_usd_at_transaction, precision: 15, scale: 2
      t.decimal :balance_btc_at_transaction, precision: 15, scale: 2
      
      t.timestamps
    end
  end
end

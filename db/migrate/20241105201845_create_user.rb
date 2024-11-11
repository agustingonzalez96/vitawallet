class CreateUser < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.decimal :balance_usd
      t.decimal :balance_btc

      t.timestamps
    end
  end
end

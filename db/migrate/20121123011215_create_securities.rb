class CreateSecurities < ActiveRecord::Migration
  def change
    create_table :securities do |t|
      t.string  :symbol     # symbol
      t.string  :type       # security type. e.g. Stock, Forex, Option
      t.float   :strike     # strike price for options
      t.string  :currency   # base currency
      t.integer :multiplier # for options
      t.date    :expiry     # expiration date for options
      t.string  :exchange   # 
      t.string  :rights     # option rights (put / call)
      t.boolean :is_active  # true if we want to gather quotes automatically
      t.timestamps
    end
    add_index :securities, :symbol, :unique => true
  end
end

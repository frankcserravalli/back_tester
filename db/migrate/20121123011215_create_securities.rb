class CreateSecurities < ActiveRecord::Migration
  def change
    create_table :securities do |t|
      t.string  :symbol      # symbol
      t.string  :description # Description of the Security
      t.string  :security_type        # security type. e.g. equity, forex, option, futures
      t.float   :strike      # strike price for options
      t.string  :currency    # base currency
      t.integer :multiplier  # for options
      t.date    :expiry      # expiration date for options
      t.string  :exchange    # Exchange this security is listed on
      t.string  :rights      # option rights (put / call)
      t.boolean :is_active   # true if we want to gather quotes automatically
      t.timestamps
    end
    add_index :securities, :symbol, :unique => true
  end
end

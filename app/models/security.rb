class Security < ActiveRecord::Base
  attr_accessible :currency, :exchange, :expiry, :is_active, :multiplier, :rights, :strike, :symbol, :type
end

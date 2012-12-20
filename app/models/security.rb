class Security < ActiveRecord::Base
  attr_accessible :currency, :exchange, :expiry, :is_active, :multiplier, :rights, :strike, :ticker, :security_type, :description
  has_many :bars, :dependent => :destroy
  has_many :index_securities
  has_many :indexes, :through => :index_securities
end

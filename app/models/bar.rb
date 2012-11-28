class Bar < ActiveRecord::Base
  attr_accessible :close, :high, :low, :open, :period, :security_id, :volume, :date
  belongs_to :security
  # validates_uniqueness_of [:security_id, :period, :date, :started_at, :ended_at]
end

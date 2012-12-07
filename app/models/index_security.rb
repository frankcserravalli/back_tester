class IndexSecurity < ActiveRecord::Base
  attr_accessible :index_id, :security_id, :weight
  belongs_to :index
  belongs_to :security
end

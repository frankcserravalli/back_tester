class Index < ActiveRecord::Base
  attr_accessible :name
  has_many :index_securities
  has_many :securities, :through => :index_securities
end

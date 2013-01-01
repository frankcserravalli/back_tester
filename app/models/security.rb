class Security < ActiveRecord::Base
  attr_accessible :currency, :exchange, :expiry, :is_active, :multiplier, :rights, :strike, :ticker, :security_type, :description
  has_many :bars, :dependent => :destroy
  has_many :index_securities
  has_many :indexes, :through => :index_securities
  
  def return_for_ranking(params = {})
    today = params[:date].to_date rescue Date.today
    # last 3 months * .70 + last 6 months * .30
    most_recent = bars.order('date asc').last.adjusted_close # rescue nil
    three_months = bars.where(["date >= ?", today - 3.months]).order('date asc').first.adjusted_close # rescue nil
    six_months = bars.where(["date >= ?", today - 6.months]).order('date asc').first.adjusted_close # rescue nil
    (((most_recent - three_months) * 0.70) + ((most_recent - six_months) * 0.30)) / most_recent.to_f 
  rescue
    nil
  end
  
  
end

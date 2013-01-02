class Security < ActiveRecord::Base
  include TechnicalAnalysis
  
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
  
  def last_price
    bars.order('date desc').first.close
  end
  
  def price_channel(params = {})
    length = params[:length] || 21 # default is approximately 1 month
    pc = {}
    series = bars.order('date desc').limit(length).map{|bar| {:date => bar.date, :high => bar.high, :low => bar.low}}
    pc[:upper] = series.map{|b| b[:high]}.max
    pc[:lower] = series.map{|b| b[:low]}.min
    pc
  end
end

ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'

@index = Index.where(["name like ?", 'Inverse ETFs']).first_or_create
@index.update_attribute(:name, 'Inverse ETFs')

INVERSE_ETFS = ['SPXU', 'SH', 'GLL', 'VXX', 'QID']

INVERSE_ETFS.each do |etf|
  s = Security.where(["ticker like ?", etf.upcase]).first_or_create
  
  is = @index.index_securities.where(["security_id = ?", s.id]).first_or_create
  is.update_attributes(
    :index_id => @index.id,
    :security_id => s.id
  )
  
  # # Get name from Yahoo!
  # y = YahooFinance.quotes([etf], [:name])
  # s.update_attributes(
  #   :ticker => etf,
  #   :description => y[0].name.gsub('"', ''),
  #   :exchange => 'NYSE', 
  #   :security_type => 'equity', 
  #   :is_active => true
  # )
  # 
  # puts "Fetching #{etf}"
  # last_day = Security.where(["ticker = ?", etf]).first.bars.order('date asc').last.date rescue Date.today - 20.years
  # yahoo = YahooQuotes.new(:symbol => etf, :start_at => last_day + 1.day)
  # 
  # yahoo.fetch.each do |y|
  #   s.bars.create(
  #     :date   => y.trade_date,
  #     :open   => y.open,
  #     :high   => y.high,
  #     :low    => y.low,
  #     :close  => y.close,
  #     :adjusted_close => y.adjusted_close,
  #     :volume => y.volume,
  #     :period => :daily
  #   )
  # end
end

puts "End of script"
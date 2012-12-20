ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'

Bar.delete_all
Security.where("is_active = 1").each do |sec|
  puts "Fetching #{sec.ticker}"
  yahoo = YahooQuotes.new(:symbol => sec.ticker, :start_at => Date.today - 50.years)
  
  yahoo.fetch.each do |y|
    sec.bars.create(
      :date   => y.trade_date,
      :open   => y.open,
      :high   => y.high,
      :low    => y.low,
      :close  => y.close,
      :adjusted_close => y.adjusted_close,
      :volume => y.volume,
      :period => :daily
    )
  end
end
puts "End of script"
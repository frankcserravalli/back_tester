ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'
symbol = ARGV[0].upcase

puts "Fetching #{symbol}"
sec = Security.find_by_symbol(symbol)
if sec
  yahoo = YahooQuotes.new(:symbol => symbol, :start_at => Date.today - 50.years)
  puts yahoo.inspect
  yahoo.fetch.each do |y|
    sec.bars.create(
      :date   => y.trade_date,
      :open   => y.open,
      :high   => y.high,
      :low    => y.low,
      :close  => y.close,
      :volume => y.volume,
      :period => :daily
    )
  end
end

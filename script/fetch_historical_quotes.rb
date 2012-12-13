ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'
ticker = ARGV[0].upcase

puts "Fetching #{ticker}"
sec = Security.find_by_ticker(ticker)
if sec
  yahoo = YahooQuotes.new(:symbol => ticker, :start_at => Date.new(2011, 1, 1))
  # puts yahoo.inspect
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

ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'

Security.where("is_active = 1").each do |sec|
  puts "Fetching #{sec.ticker}"
  yahoo = YahooQuotes.new(:symbol => sec.ticker)
  yahoo.fetch.each do |y|
    puts "\tProcessing bar for #{y.trade_date}"
    sec.bars.create(
      :date   => y.trade_date,
      :open   => y.open,
      :high   => y.high,
      :low    => y.low,
      :close  => y.close,
      # :adjusted_close => y.adjusted_close,
      :volume => y.volume,
      :period => :daily
    )
  end
end
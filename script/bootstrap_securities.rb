ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'

SECURITIES = [
  {:ticker => 'AAPL', :exchange => 'NASDAQ', :description => 'Apple', :security_type => 'equity', :is_active => true},
  {:ticker => 'GOOG', :exchange => 'NASDAQ', :description => 'Google', :security_type => 'equity', :is_active => true},
  {:ticker => 'SPY', :exchange => 'NYSE', :description => 'Spyder S&P 500 ETF', :security_type => 'equity', :is_active => true},
  {:ticker => 'DIA', :exchange => 'NYSE', :description => 'Diamonds Dow Industrials ETF', :security_type => 'equity', :is_active => true},
  {:ticker => 'QQQ', :exchange => 'NYSE', :description => 'Powershares Nasdaq 100 ETF', :security_type => 'equity', :is_active => true}]

SECURITIES.each do |sec|
  s = Security.where(["ticker like ?", sec[:ticker].upcase]).first_or_create
  s.update_attributes(sec)
end

puts "End of script"
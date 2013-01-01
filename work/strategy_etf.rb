ENV["RAILS_ENV"] = "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'csv'

include ActionView::Helpers::NumberHelper 
include TechnicalAnalysis

# 25 investment units 'IU' of 4% each
#
# From Ken Long:
# The world market model STR rating is a simplified Relative Strength calculation 
# that uses a 13 week lookback (ie 3 month) and a 26 week lookback (ie 6 month). 
# I am using a blend of 70% of the 3 month performance and 30% of the 6 month 
# performance for all 500 ETFs in the database, and then scaling the combined 
# performance from 0-100.

# Use a defined list of ETFs that represent a wide variety of investments.
# US Equities, Global Equities by region, bonds, commodities, etc.
# Each (week / month) rank the candidates by relative strength ranking.
# Accept the top 25 as long as the trailing 12 month total return is above 0.
#
# Total return = Price change + dividends. For backtesting, use the 
# adjusted_price column from Yahoo.
#
# The twelve month total return number should always > 0.
#
# For each Investment, set an initial GTC stop loss below the recent swing low.
#
# Sell when a Security drops out of the top 25 or the annual return < 0
# 
# Buy when a Security enters the top 25 and the annual return > 0
#
# Test the annual return rule to see if better results come from trailing
# 13 or 26 week annual_return stops.

@trading_days = Security.find_by_ticker('SPY').bars.where(["date >= ?", Date.today - 6.months]).order('date asc').map{|s| s.date.to_s(:db)}
# puts @trading_days.inspect
@index = Index.where(["name like ?", 'SPDR ETFs']).first
@returns = {}
@portfolio = []

i = 0
@trading_days.each do |d|  
  @index.securities.each do |s|
    @returns[s.ticker.upcase] =  s.return_for_ranking(:date => d)
  end
  p = {}
  p[:date] = d
  p[:tickers] = []
  @returns.sort_by{|k,v| v}.reverse[0..23].each do |k,v|
    p[:tickers] << k
  end
  # puts p.inspect
  @portfolio[i] = p
  if i > 0
    @portfolio[i][:additions] = @portfolio[i][:tickers] - @portfolio[i-1][:tickers]
    @portfolio[i][:subtractions] = @portfolio[i-1][:tickers] - @portfolio[i][:tickers]
  end
  puts @portfolio[i].inspect
  i += 1
end

# (1..@portfolio.length-1).each do |p|
#   
#   puts @portfolio[p]
# end

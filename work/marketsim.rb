ENV["RAILS_ENV"] = "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'csv'

include ActionView::Helpers::NumberHelper 

@initial_balance = 1000000.0
@orders_file = File.expand_path('../orders.csv', __FILE__)
@output_file = File.expand_path('../daily_balance.csv', __FILE__)

@orders  = [] # :date, :ticker, :action, :quantity
# @journal = {} # :date, :debit_account, :credit_account, :amount
@cash = @initial_balance
@portfolio = {}
@daily_values = {}
@daily_returns = {}

@spy = Security.where("ticker = 'SPY'").first

# Read the orders from the file and append to the orders array
CSV.foreach(@orders_file, :row_sep => "\r") do |row|
  @orders << {:date => Date.new(row[0].to_i, row[1].to_i, row[2].to_i), :ticker => row[3], :action => row[4], :quantity => row[5]}
end

# Sort the orders Array by date
@orders.sort_by!{|k| k[:date]}
@start_date = @orders.first[:date]
@end_date = @orders.last[:date]

@trading_days = @spy.bars.select('date').where(["date >= ? and date <= ?", (@start_date - 1.day).to_s(:db), @end_date.to_s(:db)]).map{|b| b.date.to_s(:db)}
@trading_days.sort!

# Show progress
puts ""
puts "Starting balance: #{number_to_currency @initial_balance}"
puts "Time series starts on #{@start_date}"
puts "Time series ends on #{@end_date}"
puts "#{@trading_days.count} trading days in this analysis"

@orders.each do |order|
  puts "\t#{order.inspect} @ $" + Security.where(["ticker = ?", order[:ticker]]).first.bars.where(["date = ?", order[:date].to_s(:db)]).first.adjusted_close.to_s
end

puts "Begining Value: #{number_to_currency @cash}"

puts "Trading Days:"

@trading_days.each do |td|
  puts "#{td}:"
  # Find orders if we have any for this day
  @orders.select{ |x| x[:date] == td.to_date }.each do |order|
    puts "\t#{order.inspect} @ #{number_to_currency Security.where(["ticker = ?", order[:ticker]]).first.bars.where(["date = ?", order[:date].to_s(:db)]).first.adjusted_close.to_s}"
    # Execute the orders, update the journal, and update @cash & @portfolio
    if order[:action].downcase == 'buy'
      @portfolio[order[:ticker]] = @portfolio[order[:ticker]] + order[:quantity].to_i rescue 0 + order[:quantity].to_i
      @cash = @cash - (order[:quantity].to_i * Security.where(["ticker = ?", order[:ticker]]).first.bars.where(["date = ?", order[:date].to_s(:db)]).first.adjusted_close.to_f)
    else
      @portfolio[order[:ticker]] = @portfolio[order[:ticker]] - order[:quantity].to_i rescue 0 - order[:quantity].to_i
      @cash = @cash + (order[:quantity].to_i * Security.where(["ticker = ?", order[:ticker]]).first.bars.where(["date = ?", order[:date].to_s(:db)]).first.adjusted_close.to_f)
    end
  end
  # puts "\t#{@cash}"
  @portfolio.each do |k, v|
    puts "\t#{k}: #{v} shares. #{number_to_currency(v * Security.where(["ticker = ?", k]).first.bars.where(["date = ?", td]).first.adjusted_close.to_f)}"
  end
  market_value = @cash + @portfolio.map{|k, v| v * Security.where(["ticker = ?", k]).first.bars.where(["date = ?", td]).first.adjusted_close.to_f }.inject(:+)
  @daily_values[td] = market_value
  puts "\tMarket Value: #{number_to_currency market_value}"
end # @trading_days.each
puts "Ending Value: #{number_to_currency @cash}"
puts ""
puts "Daily Values:"
previous_value = @initial_balance
@daily_values.each do |k, v|
  puts "\t#{k}: #{v}"
  @daily_returns[k] = v - previous_value
  previous_value = v
end

# puts "Daily Returns:"
# @daily_returns.each do |k, v|
#   puts "\t#{k}: #{v}"
# end

puts ""


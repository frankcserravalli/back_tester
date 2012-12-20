ENV["RAILS_ENV"] = "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'csv'

include ActionView::Helpers::NumberHelper 

@daily_values = []
@daily_returns = []

@input_file = File.expand_path('../daily_balance.csv', __FILE__)
@output_file = File.expand_path('../analysis.csv', __FILE__)
trade_days_per_year = 252.0
benchmark_rate      = 0.02 # 2%

# Read the orders from the file and append to the orders array
CSV.foreach(@input_file, :row_sep => "\r\n") do |row|
  @daily_values << {:date => row[0], :value => row[1]}
end

# puts "Daily Values:"
# @daily_values.each do |d|
#   puts "#{d[:date]}: #{d[:value]}"
# end

@daily_returns[0] = {:date => @daily_values[0][:date], :return => 0.0}

(1..@daily_values.length-1).each do |i|
  @daily_returns << {:date => @daily_values[i][:date], :return => @daily_values[i][:value].to_f - @daily_values[i-1][:value].to_f}
end

# puts "Daily Returns:"
# @daily_returns.each do |d|
#   puts "#{d[:date]}: #{d[:return]}"
# end
count = @daily_values.size
puts "Bars:           #{count}"
gain = @daily_values.last[:value].to_f - @daily_values.first[:value].to_f
puts "Gain:           #{number_to_currency gain}"
gain_percent = number_to_percentage((gain / @daily_values.first[:value].to_f) * 100)
puts "Gain Percent:   #{gain_percent}"
# Signal / Noise:
mean = @daily_returns.map{|d| d[:return]}.mean
puts "Mean Return:    #{number_to_currency mean}"
stddev = @daily_returns.map{|d| d[:return]}.standard_deviation
puts "Std Dev:        #{number_to_currency stddev}"
puts "Signal / Noise: #{mean / stddev}"
puts ""
puts 'Sharpe Ratio (annualized):'
annualized_gain = mean * trade_days_per_year
puts "\tAnnualized Gain: #{number_to_currency annualized_gain}"
benchmark_gain = @daily_values.first[:value].to_f * benchmark_rate
puts "\tBenchmark Gain:  #{number_to_currency benchmark_gain}"
benchmark_mean = benchmark_gain / trade_days_per_year
puts "\tBenckmark Mean:  #{number_to_currency benchmark_mean}"
sharpe_ratio = (mean - benchmark_mean) / stddev
puts "\tSharpe Ratio:    #{sharpe_ratio}"

# Draw a chart for Returns:
g = Gruff::Line.new(1920)
g.title = "Daily Returns"
g.theme = {
  :colors => ['black', 'grey'],
  :marker_color => 'grey',
  :font_color => 'black',
  :background_colors => 'white'
}

# g.labels = {
#   0 => '5/6',
#   1 => '5/15',
#   2 => '5/24',
#   3 => '5/30',
# }
g.data(:returns, @daily_returns.map{|d| d[:return]})
g.write("returns.png")

# Draw a chart for Values:
g = Gruff::Line.new(1920)
g.title = "Daily Account Value"
g.theme = {
  :colors => ['black', 'grey'],
  :marker_color => 'grey',
  :font_color => 'black',
  :background_colors => 'white'
}

# g.labels = {
#   0 => '5/6',
#   1 => '5/15',
#   2 => '5/24',
#   3 => '5/30',
# }
g.data(:returns, @daily_values.map{|d| d[:value].to_f})
g.write("account_values.png")
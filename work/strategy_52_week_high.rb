ENV["RAILS_ENV"] = "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'csv'

include ActionView::Helpers::NumberHelper 
include TechnicalAnalysis

big = {}
position = 'flat' # long, flat
executions = []

# puts Index.where(["name like ?", 'Dow Industrials']).first.securities.map{ |s| s.ticker }

['AAPL', 'SPY', 'DIA', 'QQQ'].each do |t| # 
# Index.where(["name like ?", 'Dow Industrials']).first.securities.map{ |s| s.ticker }.each do |t|
  big[t] = Security.where(["ticker = ?", t]).first.bars.where(["date between ? and ?", '2011-01-01', '2012-12-31']).order('date asc').map{ |b| {:ticker => t, :date => b.date.to_s(:db), :open => b.open, :high => b.high, :low => b.low, :close => b.close} }
  big["#{t}_pc_slow"] = price_channel(big[t], :length => 253, :offset => -1)
  big["#{t}_pc_fast"] = price_channel(big[t], :length => 21, :offset => -1)

  (0..big[t].length - 1).each do |i|
    msg = 'BREAKOUT' if big[t][i][:high] > big["#{t}_pc_slow"][i][:upper] rescue nil
    if msg == 'BREAKOUT' && position == 'flat'
      executions << {:date => big[t][i][:date], :ticker => t, :price => big["#{t}_pc_slow"][i][:upper], :action => 'buy'}
      position = 'long'
    elsif position == 'long' && big[t][i][:low] < big["#{t}_pc_fast"][i][:lower]
      executions << {:date => big[t][i][:date], :ticker => t, :price => big["#{t}_pc_fast"][i][:lower], :action => 'sell'}
      position = 'flat'
    end rescue nil
    # puts "#{big[t][i]} \tS:#{big["#{t}_pc_slow"][i]} \tF:#{big["#{t}_pc_fast"][i]} #{position} #{msg}"
  end
  position = 'flat'
end # each t

puts 'Executions:'
executions.each do |e|
  puts e.inspect
end
# puts position
ENV["RAILS_ENV"] = "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'csv'

include ActionView::Helpers::NumberHelper 
include TechnicalAnalysis

big = {}
position = 'flat' # long, flat
executions = []

# puts Index.where(["name like ?", 'Dow Industrials']).first.securities.map{ |s| s.ticker }

CSV.open('history.csv', 'wb', :row_sep => "\r\n") do |csv|
  csv << ['date', 'open', 'high', 'low', 'close', 'volume', 'pc_slow_upper', 'pc_slow_lower', 'pc_fast_upper', 'pc_fast_lower', 'signal']
  # ['VXX', 'SPXU', 'GLL', 'SH', 'QID'].each do |t|
  ['VXX'].each do |t| # 
    big[t] = Security.where(["ticker = ?", t]).first.bars.where(["date between ? and ?", '2000-01-01', '2012-12-31']).order('date asc').map{ |b| {:ticker => t, :date => b.date.to_s(:db), :open => b.open, :high => b.high, :low => b.low, :close => b.close, :volume  => b.volume} }
    big[t] = heikin_ashi_bar(big[t])
    big["#{t}_pc_slow"] = price_channel(big[t], :length => 21)
    big["#{t}_pc_fast"] = price_channel(big[t], :length => 2)

    @signal = 'flat'
    (21..big[t].length - 1).each do |i|
      # Check for new breakouts from a flat postion:
      if big[t][i][:high] > big["#{t}_pc_slow"][i-1][:upper] && @signal == 'flat'
        executions << {:date => big[t][i][:date], :ticker => t, :price => big["#{t}_pc_slow"][i-1][:upper], :action => 'buy', :tail => big[t][i][:high], :signal => @signal}
        position = 'long'
      end
      
      @signal = 'long' if big[t][i][:high] > big["#{t}_pc_slow"][i-1][:upper] rescue 'flat'
      @signal = 'flat' if big[t][i][:low] < big["#{t}_pc_slow"][i-1][:lower] rescue 'flat'
    
      # puts "#{big[t][i][:date]} => #{@signal} PC_SLOW: #{big["#{t}_pc_slow"][i-1][:upper]} / #{big["#{t}_pc_slow"][i-1][:lower]}"
    
      msg = 'BREAKOUT' if @signal == 'long' && big[t][i][:high] > big[t][i-1][:high] # big["#{t}_pc_fast"][i-1][:upper] rescue nil
            
      if @signal == 'long' && msg == 'BREAKOUT' && position == 'flat'
        executions << {:date => big[t][i][:date], :ticker => t, :price => big[t][i-1][:high], :action => 'buy', :tail => big[t][i][:high], :signal => @signal}
        position = 'long'
      elsif position == 'long' && big[t][i][:low] < big[t][i-1][:low] #big["#{t}_pc_fast"][i-1][:lower]
        executions << {:date => big[t][i][:date], :ticker => t, :price => big[t][i-1][:low], :action => 'sell', :tail => big[t][i][:low], :signal => @signal}
        position = 'flat'
      end rescue nil
      # puts "#{big[t][i]} \tS:#{big["#{t}_pc_slow"][i]} \tF:#{big["#{t}_pc_fast"][i]} #{position} #{msg}"
    csv << [big[t][i][:date], big[t][i][:open], big[t][i][:high], big[t][i][:low], big[t][i][:close], big[t][i][:volume], big["#{t}_pc_slow"][i-1][:upper], big["#{t}_pc_slow"][i-1][:lower], big["#{t}_pc_fast"][i-1][:upper], big["#{t}_pc_fast"][i-1][:lower], @signal]
    end
    position = 'flat'
  end # each t
end # file

# puts 'Executions:'
# executions.each do |e|
#   puts e.inspect
# end

CSV.open('executions.csv', 'wb', :row_sep => "\r\n") do |csv|
  executions.each do |e|
    puts e.inspect
    csv << [e[:date],e[:ticker],e[:price],e[:action]]
  end
end
# puts position
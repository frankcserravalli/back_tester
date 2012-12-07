ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)

analysis_start_date = '2012-10-01'
lookback_days    = 10
starting_balance = 50000 # portfolio balance
postion_size     = 5000  # size of a single position

@matrix          = {}
@model_portfolio = {}
@portfolio       = {}

@spy = Security.where("symbol = 'DIA'").first
@trading_days = @spy.bars.select('date').where(["date >= ?", analysis_start_date]).map{|b| b.date.to_s(:db)}
puts "#{@trading_days.count} trading days in this analysis"

@index = Index.where(["name like ?", 'Dow Industrials']).first
@symbols = @index.securities.map{|s| s.symbol}.sort
puts @symbols.sort.join(', ')

# matrix[:symbol][:trading_date][:close => closing price, :days_ago => change over/under days ago] ?

@trading_days.each do |td|
  @matrix[td] = {}
  @symbols.each do |symbol|
    @matrix[td][symbol] = Security.find_by_symbol(symbol).bars.where(["date = ?", td]).first.close
  end
end

# @matrix.each{|m| puts m.inspect}

@gains = {}
@trading_days.each_index do |i|
  if i > lookback_days
    # puts @trading_days[i]
    # puts @trading_days[i-lookback_days]
    today = @matrix[@trading_days[i]]
    days_ago = @matrix[@trading_days[i-lookback_days]]
    # puts today
    # puts days_ago
    
    @gains[@trading_days[i]] = {}
    @symbols.each do |symbol|
      # puts "#{symbol} for #{@trading_days[i]}: #{today[symbol]} - #{days_ago[symbol]} = #{today[symbol] - days_ago[symbol]}"
      @gains[@trading_days[i]][symbol] = (today[symbol] - days_ago[symbol].to_f)
    end # @symbols.each
  end # if
end # each

@gains.each{|m| puts m.inspect}


@gains.each do |k, v|
  # puts "#{k} top: #{v.sort_by{|k,v| v}[25..29].map{|k,v| k}.sort}\t bottom: #{v.sort_by{|k,v| v}[0..4].map{|k,v| k}.sort}"
  # puts "#{k} bottom: #{v.sort_by{|k,v| v}.first}"
  @model_portfolio[k] = {:long => v.sort_by{|k,v| v}[25..29].map{|k,v| k}.sort, :short => v.sort_by{|k,v| v}[0..4].map{|k,v| k}.sort}
end
# sort_by{|k,v| v}

@model_portfolio.each do |p|
  puts p.inspect
  # Step through the model portfolio for each day and determine if any orders need to be placed for the next day.
  
  # Place the orders
  
  # Look for open orders on the next bar.
end

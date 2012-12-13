# TimeSeries will hold a time series for a specific security
#
# * *Examples*:
#   - TimeSeries.new(:ticker => 'SPY', :series => [{:date, :open, :high, :low, :close, :adjusted_close, :volume}])
class TimeSeries
  attr_reader :series
    
  def initialize(args)
    @ticker = args[:ticker] # 'SPY'
    @series = args[:series] # [{:date, :open, :high, :low, :close, :adjusted_close, :volume}]
  end
  
  def bar_for(args)
    date   = args[:date] || Date.today.to_s(:db)
    offset = args[:offset] || 0
    Bar.new(
      @series[@series.index{|x| x[:date] == date} - offset]
    )
  end
  
  def for_day(trade_date, offset = 0)
    @series[@series.index{|x| x[:date] == trade_date} - offset]
  end

  def midpoint(trade_date, offset = 0)
    d = for_day(trade_date, offset)
    (d[:high] + d[:low]) / 2
  end
  
  def highest(trade_date, value, lookback = 0)
    this_bar = @series.index{|x| x[:date] == trade_date}
    bars_ago = this_bar - lookback
    @series[bars_ago..this_bar].map{|b| b[value.to_sym]}.max
  end
  
  
  # I am not sure how much these really help:
  def open(trade_date, offset = 0)
    for_day(trade_date, offset)[:open]
  end
  
  def high(trade_date, offset = 0)
    for_day(trade_date, offset)[:high]
  end
  
  def low(trade_date, offset = 0)
    for_day(trade_date, offset)[:low]
  end
  
  def close(trade_date, offset = 0)
    for_day(trade_date, offset)[:close]
  end
  
  def adjusted_close(trade_date, offset = 0)
    for_day(trade_date, offset)[:adjusted_close]
  end
  
  def volume(trade_date, offset = 0)
    for_day(trade_date, offset)[:volume]
  end
end

class TimeSeries::Bar
  def initialize(args)
    @args = args
  end
  
  def close
    @args[:close]
  end
  
  def midpoint
    (@args[:high] + @args[:low]) / 2
  end
end
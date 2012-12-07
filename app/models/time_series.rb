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
  
  def for_day(trade_date, offset = 0)
    @series[@series.index{|x| x[:date] == trade_date} - offset]
  end

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
  
  def midpoint(trade_date, offset = 0)
    d = for_day(trade_date, offset)
    (d[:high] + d[:low]) / 2
  end
end
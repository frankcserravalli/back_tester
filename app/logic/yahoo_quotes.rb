# Yahoo Quotes is our wrapper for the YahooFinance gem.
class YahooQuotes
  attr_reader :symbol, :start_at, :end_at, :period, :quotes
  # initialize is the constructor for the YahooQuotes class
  #
  # * *Options*:
  #   - :symbol   => Security symbol we are looking for.
  #   - :start_at => DateTime? String? to use as the starting point
  #   - :end_at   => DateTime? String? to use as the ending point
  #   - :period   => Bar size e.g. :daily
  # * *Returns*:
  #   - Description
  # * *Raises*:
  #   - Nothing
  # * *Examples*:
  #   - YahooQuotes.new(:symbol => 'SPY', :start_at => '2011-01-01', :end_at => '2011-12-31', :period => :daily)
  def initialize(args = {})
    @symbol   = args[:symbol]
    @start_at = args[:start_at].to_datetime rescue Date.today  # Convert to DateTime
    @end_at   = args[:end_at].to_datetime rescue Date.today   # Convert to DateTime
    @period   = args[:period] || :daily
  end
  
  def fetch
    YahooFinance.historical_quotes(@symbol, @start_at, @end_at, {:period => @period})
  end
end
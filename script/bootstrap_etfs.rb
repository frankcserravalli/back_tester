ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'

@index = Index.where(["name like ?", 'ETFs']).first_or_create
@index.update_attribute(:name, 'ETFs')

ETFS = [
  {:ticker => 'DBA', :exchange => 'NYSE', :description => 'PowerShares Agriculture', :security_type => 'equity', :is_active => true},
  {:ticker => 'DBC', :exchange => 'NYSE', :description => 'PowerShares Commodities', :security_type => 'equity', :is_active => true},
  {:ticker => 'DIA', :exchange => 'NYSE', :description => 'Dow 30 Industrials', :security_type => 'equity', :is_active => true},
  {:ticker => 'EEB', :exchange => 'NYSE', :description => 'Claymore / BNY Bric', :security_type => 'equity', :is_active => true},
  {:ticker => 'EEM', :exchange => 'NYSE', :description => 'iShares MSCI Emerging Markets', :security_type => 'equity', :is_active => true},
  {:ticker => 'EFA', :exchange => 'NYSE', :description => 'iShares EAFE Index', :security_type => 'equity', :is_active => true},
  {:ticker => 'EPP', :exchange => 'NYSE', :description => 'iShares Asia less Japan', :security_type => 'equity', :is_active => true},
  {:ticker => 'EMB', :exchange => 'NYSE', :description => 'iShares Emerging Markets Bond', :security_type => 'equity', :is_active => true},
  {:ticker => 'EWA', :exchange => 'NYSE', :description => 'iShares Australia', :security_type => 'equity', :is_active => true},
  {:ticker => 'EWJ', :exchange => 'NYSE', :description => 'iShares Japan', :security_type => 'equity', :is_active => true},
  {:ticker => 'EWZ', :exchange => 'NYSE', :description => 'iShares Brazil', :security_type => 'equity', :is_active => true},
  {:ticker => 'FXF', :exchange => 'NYSE', :description => 'Currency Shares CHF', :security_type => 'equity', :is_active => true},  
  {:ticker => 'FXI', :exchange => 'NYSE', :description => 'iShares China', :security_type => 'equity', :is_active => true},
  {:ticker => 'GDX', :exchange => 'NYSE', :description => 'Market Vectors Gold Miners ETF', :security_type => 'equity', :is_active => true},
  {:ticker => 'GLD', :exchange => 'NYSE', :description => 'streetTRACKS Gold', :security_type => 'equity', :is_active => true},
  {:ticker => 'GUR', :exchange => 'NYSE', :description => 'SPDR Emerging Europe', :security_type => 'equity', :is_active => true},
  {:ticker => 'HYG', :exchange => 'NYSE', :description => 'iShares High Yield Corporate Bonds', :security_type => 'equity', :is_active => true},  
  {:ticker => 'IEV', :exchange => 'NYSE', :description => 'iShares S&P 500 Europe', :security_type => 'equity', :is_active => true},
  {:ticker => 'ILF', :exchange => 'NYSE', :description => 'iShares Latin America', :security_type => 'equity', :is_active => true},
  {:ticker => 'IWM', :exchange => 'NYSE', :description => 'iShares Russell 2000', :security_type => 'equity', :is_active => true},
  {:ticker => 'IYR', :exchange => 'NYSE', :description => 'iShares US Real Estate', :security_type => 'equity', :is_active => true},
  {:ticker => 'KOL', :exchange => 'NYSE', :description => 'Coal', :security_type => 'equity', :is_active => true},
  {:ticker => 'LQD', :exchange => 'NYSE', :description => 'iShares Investment Grade Bonds', :security_type => 'equity', :is_active => true},  
  {:ticker => 'MDY', :exchange => 'NYSE', :description => 'Russell Mid-Cap 400', :security_type => 'equity', :is_active => true},
  {:ticker => 'QQQ', :exchange => 'NYSE', :description => 'PowerShares Nasdaq 100', :security_type => 'equity', :is_active => true},
  {:ticker => 'SLV', :exchange => 'NYSE', :description => 'Silver', :security_type => 'equity', :is_active => true},
  {:ticker => 'SPY', :exchange => 'NYSE', :description => 'SPDR S&P 500', :security_type => 'equity', :is_active => true},
  {:ticker => 'TLT', :exchange => 'NYSE', :description => 'iShares Long Term Treasuries', :security_type => 'equity', :is_active => true},
  {:ticker => 'UNG', :exchange => 'NYSE', :description => 'Natural Gas', :security_type => 'equity', :is_active => true},
  {:ticker => 'USO', :exchange => 'NYSE', :description => 'Oil', :security_type => 'equity', :is_active => true},
  {:ticker => 'VWO', :exchange => 'NYSE', :description => 'Vanguard Emerging Markets', :security_type => 'equity', :is_active => true},
  {:ticker => 'XLB', :exchange => 'NYSE', :description => 'SPDR S&P 500 Basic Materials', :security_type => 'equity', :is_active => true},
  {:ticker => 'XLE', :exchange => 'NYSE', :description => 'SPDR S&P 500 Energy', :security_type => 'equity', :is_active => true},
  {:ticker => 'XLF', :exchange => 'NYSE', :description => 'SPDR S&P 500 Finance', :security_type => 'equity', :is_active => true},
  {:ticker => 'XLI', :exchange => 'NYSE', :description => 'SPDR S&P 500 Industrial', :security_type => 'equity', :is_active => true},
  {:ticker => 'XLK', :exchange => 'NYSE', :description => 'SPDR S&P 500 Technology', :security_type => 'equity', :is_active => true},
  {:ticker => 'XLP', :exchange => 'NYSE', :description => 'SPDR S&P 500 Consumer Staples', :security_type => 'equity', :is_active => true},
  {:ticker => 'XLU', :exchange => 'NYSE', :description => 'SPDR S&P 500 Utilities', :security_type => 'equity', :is_active => true},
  {:ticker => 'XLV', :exchange => 'NYSE', :description => 'SPDR S&P 500 Healthcare', :security_type => 'equity', :is_active => true},  
  {:ticker => 'XLY', :exchange => 'NYSE', :description => 'SPDR S&P 500 Consumer Discretionary', :security_type => 'equity', :is_active => true},
  {:ticker => 'XOP', :exchange => 'NYSE', :description => 'SPDR S&P Oil & Gas Exploration', :security_type => 'equity', :is_active => true},  
  {:ticker => 'XRT', :exchange => 'NYSE', :description => 'SPDR S&P 500 Retail', :security_type => 'equity', :is_active => true}]

  # {:ticker => 'VXX', :exchange => 'NYSE', :description => 'Vix', :security_type => 'equity', :is_active => true},
  # {:ticker => 'SH', :exchange => 'NYSE', :description => 'Short S&P 500', :security_type => 'equity', :is_active => true},

  # NOTE: A simpler way to do this is to look up the names from Yahoo! in order to eliminate the need to type out the names, etc.

ETFS.each do |d|
  s = Security.where(["ticker like ?", d[:ticker].upcase]).first_or_create
  s.update_attributes(d)
  is = @index.index_securities.where(["security_id = ?", s.id]).first_or_create
  is.update_attributes(
    :index_id => @index.id,
    :security_id => s.id
  )
  
  puts "Fetching #{d[:ticker].upcase}"
  last_day = Security.where(["ticker = ?", d[:ticker].upcase]).first.bars.order('date asc').last.date rescue Date.today - 20.years
  yahoo = YahooQuotes.new(:symbol => d[:ticker].upcase, :start_at => last_day + 1.day)

  yahoo.fetch.each do |y|
    s.bars.create(
      :date   => y.trade_date,
      :open   => y.open,
      :high   => y.high,
      :low    => y.low,
      :close  => y.close,
      :adjusted_close => y.adjusted_close,
      :volume => y.volume,
      :period => :daily
    )
  end
end

puts "End of script"
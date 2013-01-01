ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'

@index = Index.where(["name like ?", 'ETFs']).first_or_create
@index.update_attribute(:name, 'ETFs')

# 'AGG', 'BIL', 'BIV', 'BKF', 'BND', 'BSV', 'BWX', 'CIU', 'CSJ', 'CVY', 'DBA', 'DBB', 'DBC', 'DBO', 'DEM', 'DGS', 'DIA', 'DJP', 'DLN', 'DTN', 'DVY', 'DXJ', 'ECH', 'EEB', 'EEM', 'EFA', 'EFG', 'EFV', 'EMB', 'EPP', 'EWA', 'EWC', 'EWD', 'EWG', 'EWH', 'EWI', 'EWJ', 'EWK', 'EWL', 'EWM', 'EWN', 'EWO', 'EWP', 'EWQ', 'EWS', 'EWT', 'EWU', 'EWW', 'EWY', 'EWZ', 'EZA', 'EZU', 'FCG', 'FDL', 'FDN', 'FEZ', 'FRI', 'FVD', 'FXA', 'FXD', 'FXE', 'FXF', 'FXG', 'FXH', 'FXI', 'FXL', 'FXN', 'FXO', 'FXR', 'FXU', 'FXY', 'FXZ', 'GDX', 'GLD', 'GSG', 'GUR', 'GXC', 'HYG', 'IAU', 'IBB', 'ICF', 'IDU', 'IDV', 'IEF', 'IEI', 'IEV', 

ETFS = ['AGG', 'BIL', 'BIV', 'BKF', 'BND', 'BSV', 'BWX', 'CIU', 'CSJ', 'CVY', 'DBA', 'DBB', 'DBC', 'DBO', 'DEM', 'DGS', 'DIA', 'DJP', 'DLN', 'DTN', 'DVY', 'DXJ', 'ECH', 'EEB', 'EEM', 'EFA', 'EFG', 'EFV', 'EMB', 'EPP', 'EWA', 'EWC', 'EWD', 'EWG', 'EWH', 'EWI', 'EWJ', 'EWK', 'EWL', 'EWM', 'EWN', 'EWO', 'EWP', 'EWQ', 'EWS', 'EWT', 'EWU', 'EWW', 'EWY', 'EWZ', 'EZA', 'EZU', 'FCG', 'FDL', 'FDN', 'FEZ', 'FRI', 'FVD', 'FXA', 'FXD', 'FXE', 'FXF', 'FXG', 'FXH', 'FXI', 'FXL', 'FXN', 'FXO', 'FXR', 'FXU', 'FXY', 'FXZ', 'GDX', 'GLD', 'GSG', 'GUR', 'GXC', 'HYG', 'IAU', 'IBB', 'ICF', 'IDU', 'IDV', 'IEF', 'IEI', 'IEV', 'IGE', 'IJH', 'IJJ', 'IJK', 'IJR', 'IJS', 'ILF', 'ITB', 'ITM', 'IVE', 'IVV', 'IVW', 'IWB', 'IWD', 'IWF', 'IWM', 'IWN', 'IWO', 'IWP', 'IWR', 'IWS', 'IWV', 'IXC', 'IYE', 'IYF', 'IYJ', 'IYM', 'IYR', 'IYT', 'IYW', 'IYZ', 'JNK', 'KBE', 'KOL', 'KRE', 'LQD', 'MBB', 'MDY', 'MGK', 'MOO', 'MUB', 'OEF', 'OIH', 'OIL', 'PBP', 'PBS', 'PBW', 'PCY', 'PDP', 'PEY', 'PFF', 'PGF', 'PHB', 'PHO', 'PID', 'PIE', 'PSP', 'PVI', 'PWV', 'PXH', 'PZA', 'QQQ', 'REM', 'RJA', 'RJI', 'RSP', 'RSX', 'RTH', 'RWR', 'RWX', 'SCZ', 'SDY', 'SHM', 'SHV', 'SHY', 'SLV', 'SMH', 'SPY', 'TFI', 'TIP', 'TLT', 'UNG', 'USO', 'UUP', 'VB', 'VBR', 'VDE', 'VEA', 'VEU', 'VFH', 'VGK', 'VGT', 'VIG', 'VNQ', 'VO', 'VPL', 'VTI', 'VTV', 'VUG', 'VV', 'VWO', 'VXF', 'VYM', 'XBI', 'XES', 'XLB', 'XLE', 'XLF', 'XLI', 'XLK', 'XLP', 'XLU', 'XLV', 'XLY', 'XME', 'XOP', 'XRT']

# BAD TICKERS? 'IFGL', 'IFN', 

ETFS.each do |etf|
  s = Security.where(["ticker like ?", etf.upcase]).first_or_create
  
  is = @index.index_securities.where(["security_id = ?", s.id]).first_or_create
  is.update_attributes(
    :index_id => @index.id,
    :security_id => s.id
  )
  
  # Get name from Yahoo!
  y = YahooFinance.quotes([etf], [:name])
  s.update_attributes(
    :ticker => etf,
    :description => y[0].name.gsub('"', ''),
    :exchange => 'NYSE', 
    :security_type => 'equity', 
    :is_active => true
  )
  
  puts "Fetching #{etf}"
  last_day = Security.where(["ticker = ?", etf]).first.bars.order('date asc').last.date rescue Date.today - 20.years
  yahoo = YahooQuotes.new(:symbol => etf, :start_at => last_day + 1.day)
  
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

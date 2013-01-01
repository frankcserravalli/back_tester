ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'
index_name = 'iShares ETFs'

@index = Index.where(["name like ?", index_name]).first_or_create
@index.update_attribute(:name, index_name)

ETFS = ['CLY', 'MUAB', 'MUAC', 'MUAD', 'MUAE', 'MUAF', 'QLTA', 'DVYA', 'QLTC', 'QLTB', 'STIP', 'CSJ', 'SHY', 'TLH', 'TLT', 'IEI', 'IEF', 'AGZ', 'CMBS', 'CFT', 'GNMA', 'GBF', 'CIU', 'GVI', 'MBB', 'SHV', 'TIP', 'GOVT', 'ICF', 'ILTB', 'IEFA', 'IEMG', 'IXUS', 'IVV', 'IJH', 'IJR', 'ITOT', 'ISTB', 'AGG', 'IDV', 'DVY', 'IYT', 'ITA', 'IYM', 'IAI', 'IYK', 'IYC', 'IYE', 'IYF', 'IYG', 'IHF', 'IYH', 'ITB', 'IYY', 'IYJ', 'IAK', 'IHI', 'IEO', 'IEZ', 'IHE', 'IYR', 'IAT', 'IYW', 'IYZ', 'IDU', 'CEMB', 'DVYE', 'EMHY', 'LEMB', 'MONY', 'FLOT', 'FCHI', 'FXI', 'IFSM', 'IFAS', 'IFEU', 'IFGL', 'IFNA', 'FNIO', 'REM', 'FTY', 'REZ', 'RTL', 'HYXU', 'GHYG', 'GTIP', 'HDV', 'HYG', 'LQD', 'ENGN', 'ITIP', 'EMB', 'JKD', 'JKE', 'JKF', 'JKG', 'JKH', 'JKI', 'IYLD', 'JKJ', 'JKK', 'JKL', 'AXDI', 'AXSL', 'AXEN', 'AXFN', 'AXHE', 'ACWX', 'AXID', 'AXIT', 'AXMT', 'AXTE', 'AXUT', 'ACWI', 'AAXJ', 'AXJS', 'AAIT', 'ACWV', 'EPU', 'EWA', 'EWAS', 'EWO', 'EWK', 'EWZ', 'EWZS', 'BKF', 'EWC', 'EWCS', 'ECH', 'MCHI', 'ECNS', 'EDEN', 'EFG', 'EFA', 'EFAV', 'SCZ', 'EFV', 'EEMA', 'EMDI', 'ESR', 'EEME', 'EMEY', 'EMFN', 'EGRW', 'EEM', 'EEML', 'EMMT', 'EEMV', 'EEMS', 'EVAL', 'EZU', 'EUFN', 'FEFN', 'EFNL', 'EWQ', 'FM', 'EWG', 'EWGS', 'VEGI', 'FILL', 'RING', 'PICK', 'SLVP', 'EWH', 'EWHS', 'INDA', 'SMIN', 'EIDO', 'EIRL', 'EIS', 'EWI', 'EWJ', 'SCJ', 'DSI', 'TOK', 'EWM', 'EWW', 'EWN', 'ENZL', 'ENOR', 'EPP', 'EPHE', 'EPOL', 'ERUS', 'EWS', 'EWSS', 'EZA', 'EWY', 'EWP', 'EWD', 'EWL', 'EWT', 'THD', 'TUR', 'EWU', 'EWUS', 'KLD', 'EUSA', 'USMV', 'URTH', 'IBB', 'NY', 'NYC', 'SOXX', 'IWF', 'IWB', 'IWD', 'IWO', 'IWM', 'IWN', 'IWZ', 'IWV', 'IWW', 'IWC', 'IWP', 'IWR', 'IWS', 'IWY', 'IWL', 'IWX', 'OEF', 'IVW', 'IVE', 'AOA', 'AIA', 'CMF', 'AOK', 'WPS', 'EMIF', 'IEV', 'IOO', 'ICLN', 'RXI', 'KXI', 'IXC', 'IXG', 'IXJ', 'EXI', 'IGF', 'MXI', 'NUCL', 'IXN', 'IXP', 'WOOD', 'JXI', 'AOR', 'INDY', 'IPFF', 'ILF', 'IJK', 'IJJ', 'AOM', 'MUB', 'NYF', 'IGE', 'IGM', 'IGN', 'IGV', 'SUB', 'IJT', 'IJS', 'TZD', 'TZE', 'TZG', 'TZI', 'TZL', 'TZO', 'TZV', 'TZW', 'TZY', 'TGR', 'PFF', 'ISHG', 'IGOV', 'ITF', 'AMPS']

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

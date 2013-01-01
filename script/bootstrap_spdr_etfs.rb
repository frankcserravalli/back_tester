ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'
index_name = 'SPDR ETFs'

@index = Index.where(["name like ?", index_name]).first_or_create
@index.update_attribute(:name, index_name)

ETFS = ['SPYG', 'SPYV', 'ELR', 'EMM', 'MDYV', 'MDYG', 'MDY', 'SLYV', 'SLYG', 'SLY', 'SDY', 'TMW', 'VLU', 'DIA', 'SPY', 'MMTM', 'IPD', 'XRT', 'XHB', 'XLY', 'IPS', 'XLP', 'XES', 'XOP', 'IPW', 'XLE', 'KRE', 'IPF', 'KCE', 'KBE', 'KME', 'KIE', 'XLF', 'IRY', 'XLV', 'XHS', 'XHE', 'XBI', 'XPH', 'XTN', 'XAR', 'XLI', 'IPN', 'XME', 'XLB', 'IRV', 'XSW', 'XSD', 'IPK', 'XLK', 'MTK', 'IST', 'XTL', 'XLU', 'IPU', 'RWR', 'RWO', 'RWX', 'GLD', 'GAL', 'RLY', 'INKM', 'DGT', 'GMFS', 'EDIV', 'BIK', 'EMFT', 'GMM', 'EWX', 'ACIM', 'GNR', 'GWL', 'GII', 'CWI', 'DWX', 'GWX', 'MDD', 'GXC', 'GMF', 'JPP', 'JSC', 'FEU', 'RBL', 'FEZ', 'GUR', 'GML', 'GAF', 'LAG', 'LWC', 'SCPB', 'ITR', 'XOVR', 'CBND', 'BWX', 'EBND', 'EMCD', 'IBND', 'BWZ', 'BIL', 'ITE', 'TLO', 'JNK', 'PSK', 'CWB', 'WIP', 'IPE', 'MBG', 'CXA', 'BABS', 'TFI', 'SHM', 'HYMB', 'VRD', 'INY', 'SST', 'SJNK', 'FLRN']

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

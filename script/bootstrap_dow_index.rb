ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'

@index = Index.where(["name like ?", 'Dow Industrials']).first_or_create
@index.update_attribute(:name, 'Dow Industrials')

DOW = [
  {:ticker => 'MMM', :exchange => 'NYSE', :description => '3M', :security_type => 'equity', :is_active => true},
  {:ticker => 'AA', :exchange => 'NYSE', :description => 'Alcoa', :security_type => 'equity', :is_active => true},
  {:ticker => 'AXP', :exchange => 'NYSE', :description => 'American Express', :security_type => 'equity', :is_active => true},
  {:ticker => 'T', :exchange => 'NYSE', :description => 'AT&T', :security_type => 'equity', :is_active => true},
  {:ticker => 'BAC', :exchange => 'NYSE', :description => 'Bank of America', :security_type => 'equity', :is_active => true},
  {:ticker => 'BA', :exchange => 'NYSE', :description => 'Boeing', :security_type => 'equity', :is_active => true},
  {:ticker => 'CAT', :exchange => 'NYSE', :description => 'Caterpillar', :security_type => 'equity', :is_active => true},
  {:ticker => 'CVX', :exchange => 'NYSE', :description => 'Chevron Corporation', :security_type => 'equity', :is_active => true},
  {:ticker => 'CSCO', :exchange => 'NASDAQ', :description => 'Cisco Systems', :security_type => 'equity', :is_active => true},
  {:ticker => 'KO', :exchange => 'NYSE', :description => 'Coca-Cola', :security_type => 'equity', :is_active => true},
  {:ticker => 'DD', :exchange => 'NYSE', :description => 'DuPont', :security_type => 'equity', :is_active => true},
  {:ticker => 'XOM', :exchange => 'NYSE', :description => 'ExxonMobil', :security_type => 'equity', :is_active => true},
  {:ticker => 'GE', :exchange => 'NYSE', :description => 'General Electric', :security_type => 'equity', :is_active => true},
  {:ticker => 'HPQ', :exchange => 'NYSE', :description => 'Hewlett-Packard', :security_type => 'equity', :is_active => true},
  {:ticker => 'HD', :exchange => 'NYSE', :description => 'The Home Depot', :security_type => 'equity', :is_active => true},
  {:ticker => 'INTC', :exchange => 'NASDAQ', :description => 'Intel', :security_type => 'equity', :is_active => true},
  {:ticker => 'IBM', :exchange => 'NYSE', :description => 'IBM', :security_type => 'equity', :is_active => true},
  {:ticker => 'JNJ', :exchange => 'NYSE', :description => 'Johnson & Johnson', :security_type => 'equity', :is_active => true},
  {:ticker => 'JPM', :exchange => 'NYSE', :description => 'JPMorgan Chase', :security_type => 'equity', :is_active => true},
  {:ticker => 'MCD', :exchange => 'NYSE', :description => 'McDonalds', :security_type => 'equity', :is_active => true},
  {:ticker => 'MRK', :exchange => 'NYSE', :description => 'Merck', :security_type => 'equity', :is_active => true},
  {:ticker => 'MSFT', :exchange => 'NASDAQ', :description => 'Microsoft', :security_type => 'equity', :is_active => true},
  {:ticker => 'PFE', :exchange => 'NYSE', :description => 'Pfizer', :security_type => 'equity', :is_active => true},
  {:ticker => 'PG', :exchange => 'NYSE', :description => 'Procter & Gamble', :security_type => 'equity', :is_active => true},
  {:ticker => 'TRV', :exchange => 'NYSE', :description => 'Travelers', :security_type => 'equity', :is_active => true},
  {:ticker => 'UNH', :exchange => 'NYSE', :description => 'UnitedHealth Group', :security_type => 'equity', :is_active => true},
  {:ticker => 'UTX', :exchange => 'NYSE', :description => 'United Technologies Corporation', :security_type => 'equity', :is_active => true},
  {:ticker => 'VZ', :exchange => 'NYSE', :description => 'Verizon', :security_type => 'equity', :is_active => true},
  {:ticker => 'WMT', :exchange => 'NYSE', :description => 'Wal-Mart', :security_type => 'equity', :is_active => true},
  {:ticker => 'DIS', :exchange => 'NYSE', :description => 'Walt Disney', :security_type => 'equity', :is_active => true}]

DOW.each do |d|
  s = Security.where(["ticker like ?", d[:ticker].upcase]).first_or_create
  s.update_attributes(d)
  is = @index.index_securities.where(["security_id = ?", s.id]).first_or_create
  is.update_attributes(
    :index_id => @index.id,
    :security_id => s.id
  )
end

puts "End of script"
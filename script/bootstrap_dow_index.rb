ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'yahoo_finance'

@index = Index.where(["name like ?", 'Dow Industrials']).first_or_create
@index.update_attribute(:name, 'Dow Industrials')

DOW = [
  {:symbol => 'MMM', :exchange => 'NYSE', :description => '3M', :security_type => 'equity', :is_active => true},
  {:symbol => 'AA', :exchange => 'NYSE', :description => 'Alcoa', :security_type => 'equity', :is_active => true},
  {:symbol => 'AXP', :exchange => 'NYSE', :description => 'American Express', :security_type => 'equity', :is_active => true},
  {:symbol => 'T', :exchange => 'NYSE', :description => 'AT&T', :security_type => 'equity', :is_active => true},
  {:symbol => 'BAC', :exchange => 'NYSE', :description => 'Bank of America', :security_type => 'equity', :is_active => true},
  {:symbol => 'BA', :exchange => 'NYSE', :description => 'Boeing', :security_type => 'equity', :is_active => true},
  {:symbol => 'CAT', :exchange => 'NYSE', :description => 'Caterpillar', :security_type => 'equity', :is_active => true},
  {:symbol => 'CVX', :exchange => 'NYSE', :description => 'Chevron Corporation', :security_type => 'equity', :is_active => true},
  {:symbol => 'CSCO', :exchange => 'NASDAQ', :description => 'Cisco Systems', :security_type => 'equity', :is_active => true},
  {:symbol => 'KO', :exchange => 'NYSE', :description => 'Coca-Cola', :security_type => 'equity', :is_active => true},
  {:symbol => 'DD', :exchange => 'NYSE', :description => 'DuPont', :security_type => 'equity', :is_active => true},
  {:symbol => 'XOM', :exchange => 'NYSE', :description => 'ExxonMobil', :security_type => 'equity', :is_active => true},
  {:symbol => 'GE', :exchange => 'NYSE', :description => 'General Electric', :security_type => 'equity', :is_active => true},
  {:symbol => 'HPQ', :exchange => 'NYSE', :description => 'Hewlett-Packard', :security_type => 'equity', :is_active => true},
  {:symbol => 'HD', :exchange => 'NYSE', :description => 'The Home Depot', :security_type => 'equity', :is_active => true},
  {:symbol => 'INTC', :exchange => 'NASDAQ', :description => 'Intel', :security_type => 'equity', :is_active => true},
  {:symbol => 'IBM', :exchange => 'NYSE', :description => 'IBM', :security_type => 'equity', :is_active => true},
  {:symbol => 'JNJ', :exchange => 'NYSE', :description => 'Johnson & Johnson', :security_type => 'equity', :is_active => true},
  {:symbol => 'JPM', :exchange => 'NYSE', :description => 'JPMorgan Chase', :security_type => 'equity', :is_active => true},
  {:symbol => 'MCD', :exchange => 'NYSE', :description => 'McDonalds', :security_type => 'equity', :is_active => true},
  {:symbol => 'MRK', :exchange => 'NYSE', :description => 'Merck', :security_type => 'equity', :is_active => true},
  {:symbol => 'MSFT', :exchange => 'NASDAQ', :description => 'Microsoft', :security_type => 'equity', :is_active => true},
  {:symbol => 'PFE', :exchange => 'NYSE', :description => 'Pfizer', :security_type => 'equity', :is_active => true},
  {:symbol => 'PG', :exchange => 'NYSE', :description => 'Procter & Gamble', :security_type => 'equity', :is_active => true},
  {:symbol => 'TRV', :exchange => 'NYSE', :description => 'Travelers', :security_type => 'equity', :is_active => true},
  {:symbol => 'UNH', :exchange => 'NYSE', :description => 'UnitedHealth Group', :security_type => 'equity', :is_active => true},
  {:symbol => 'UTX', :exchange => 'NYSE', :description => 'United Technologies Corporation', :security_type => 'equity', :is_active => true},
  {:symbol => 'VZ', :exchange => 'NYSE', :description => 'Verizon', :security_type => 'equity', :is_active => true},
  {:symbol => 'WMT', :exchange => 'NYSE', :description => 'Wal-Mart', :security_type => 'equity', :is_active => true},
  {:symbol => 'DIS', :exchange => 'NYSE', :description => 'Walt Disney', :security_type => 'equity', :is_active => true}]

DOW.each do |d|
  s = Security.where(["symbol like ?", d[:symbol].upcase]).first_or_create
  s.update_attributes(d)
  is = @index.index_securities.where(["security_id = ?", s.id]).first_or_create
  is.update_attributes(
    :index_id => @index.id,
    :security_id => s.id
  )
end

puts "End of script"
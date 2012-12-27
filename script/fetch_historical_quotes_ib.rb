ENV["RAILS_ENV"] = "development" # ARGV[0].nil? ? "production" : "development"
require File.expand_path('../../config/environment',  __FILE__)
require 'ib-ruby'
ticker = ARGV[0].upcase

puts "Fetching #{ticker}"
sec = Security.find_by_ticker(ticker)
sec.bars.delete_all

if sec
  @market = {sec.id => IB::Symbols::Stocks[:vxx]}
  # Connect to IB TWS.
  ib = IB::Connection.new :client_id => 1112, :port => 7496 # TWS

  # Subscribe to TWS alerts/errors
  ib.subscribe(:Alert) { |msg| puts msg.to_human }

  # Subscribe to HistoricalData incoming events. The code passed in the block
  # will be executed when a message of that type is received, with the received
  # message as its argument. In this case, we just print out the data.
  #
  # Note that we have to look the ticker id of each incoming message
  # up in local memory to figure out what it's for.
  ib.subscribe(IB::Messages::Incoming::HistoricalData) do |msg|
    puts @market[msg.request_id].description + ": #{msg.count} items:"
    msg.results.each { |entry| 
      puts "#{entry.inspect}" 
      puts "\t#{entry.open} #{entry.high} #{entry.low} #{entry.close} #{entry.volume} #{entry.time.to_date}"
      sec.bars.create(
        :date   => entry.time.to_date.to_s(:db),
        :open   => entry.open,
        :high   => entry.high,
        :low    => entry.low,
        :close  => entry.close,
        # :adjusted_close => y.adjusted_close,
        :volume => entry.volume,
        :period => :daily
      )
    }
  end

  # Now we actually request historical data for the symbols we're interested in. TWS will
  # respond with a HistoricalData message, which will be processed by the code above.
  @market.each_pair do |id, contract|
    ib.send_message IB::Messages::Outgoing::RequestHistoricalData.new(
                        :request_id => id,
                        :contract => contract,
                        :end_date_time => Time.now.to_ib,
                        :duration => '1 Y', # ?
                        :bar_size => '1 day', # IB::BAR_SIZES.key(:hour)?
                        :what_to_show => :trades,
                        :use_rth => 1,
                        :format_date => 1)
  end

  # IB does not send any indication when all historic data is done being delivered.
  # So we need to interrupt manually when our request is answered.
  puts "\n******** Press <Enter> to exit... *********\n\n"
  STDIN.gets
end # if sec

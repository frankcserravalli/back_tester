require File.expand_path('../../test_helper',  __FILE__)
# require 'test_helper'

class TimeSeriesTest < ActiveSupport::TestCase
  def setup
    @t = TimeSeries.new(:symbol => 'SPY', 
                        :series => [
                          {:date => (Date.today-1.day).to_s(:db), :open => 2.0, :high => 3.0, :low => 2.0, :close => 2.5, :adjusted_close => 2.5, :volume => 200},
                          {:date => Date.today.to_s(:db), :open => 1.0, :high => 2.0, :low => 1.0, :close => 1.5, :adjusted_close => 1.5, :volume => 100}
                         ]
                        )
  end
  
  test "instantiation" do
    assert @t
  end
  
  test "for_day()" do
    assert_equal Hash[:date, Date.today.to_s(:db), :open, 1.0, :high, 2.0, :low, 1.0, :close, 1.5, :adjusted_close, 1.5, :volume, 100], @t.for_day(Date.today.to_s(:db))
  end

  test "series()" do
    assert_equal [
      {:date => (Date.today-1.day).to_s(:db), :open => 2.0, :high => 3.0, :low => 2.0, :close => 2.5, :adjusted_close => 2.5, :volume => 200},
      {:date => Date.today.to_s(:db), :open => 1.0, :high => 2.0, :low => 1.0, :close => 1.5, :adjusted_close => 1.5, :volume => 100}],
      @t.series
  end

  test "highest()" do
    assert_equal 2.5, @t.highest(Date.today.to_s(:db), :close, 1)
  end

  test "bar_for" do
   # puts @t.bar_for(:date => Date.today.to_s(:db)).inspect
   bar = @t.bar_for(:date => Date.today.to_s(:db))
   # assert_equal 1.0, bar.open
   # assert_equal 2.0, bar.high
   # assert_equal 1.0, bar.low
   assert_equal 1.5, bar.close
   # assert_equal 1.5, bar.adjusted_close
   # assert_equal 100, bar.volume
   assert_equal 1.5, bar.midpoint
  end

  # Not sure these methods help:
  # test "open()" do
  #   assert_equal 1.0, @t.open(Date.today.to_s(:db))
  #   assert_equal 2.0, @t.open(Date.today.to_s(:db), 1)
  # end
  # 
  # test "high()" do
  #   assert_equal 2.0, @t.high(Date.today.to_s(:db))
  #   assert_equal 3.0, @t.high(Date.today.to_s(:db), 1)
  # end
  # 
  # test "low()" do
  #   assert_equal 1.0, @t.low(Date.today.to_s(:db))
  #   assert_equal 2.0, @t.low(Date.today.to_s(:db), 1)
  # end
  # 
  # test "close()" do
  #   assert_equal 1.5, @t.close(Date.today.to_s(:db))
  #   assert_equal 2.5, @t.close(Date.today.to_s(:db), 1)
  # end
  # 
  # test "adjusted_close()" do
  #   assert_equal 1.5, @t.adjusted_close(Date.today.to_s(:db))
  #   assert_equal 2.5, @t.adjusted_close(Date.today.to_s(:db), 1)
  # end
  # 
  # test "volume()" do
  #   assert_equal 100, @t.volume(Date.today.to_s(:db))
  #   assert_equal 200, @t.volume(Date.today.to_s(:db), 1)
  # end
  # 
  # test "midpoint()" do
  #   assert_equal 1.5, @t.midpoint(Date.today.to_s(:db))
  #   assert_equal 2.5, @t.midpoint(Date.today.to_s(:db), 1)
  # end
end

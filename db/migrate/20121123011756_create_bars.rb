class CreateBars < ActiveRecord::Migration
  def change
    create_table :bars do |t|
      t.integer :security_id # related Security
      t.string  :period      # Period (e.g. hourly, daily, weekly)
      t.float   :open        
      t.float   :high
      t.float   :low
      t.float   :close
      t.float   :wap
      t.integer :volume
      t.date    :date        # the market date
      t.time    :started_at  # time the bar starts if less than a day
      t.time    :ended_at    # time the bar ends if less than a day
      t.timestamps
    end
    add_index :bars, :security_id
    add_index :bars, :date
    # Bar.connection.execute("CREATE UNIQUE INDEX unique_bars ON bars(security_id, period, date, started_at, ended_at)")
  end
end

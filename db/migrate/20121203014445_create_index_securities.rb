class CreateIndexSecurities < ActiveRecord::Migration
  def change
    create_table :index_securities do |t|
      t.integer :index_id
      t.integer :security_id
      t.float :weight
      t.timestamps
    end
    add_index :index_securities, :index_id
    add_index :index_securities, :security_id
  end
end

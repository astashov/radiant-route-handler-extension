class CreateRouteHandlers < ActiveRecord::Migration
  def self.up
    create_table :route_handlers do |t|
      t.string :url, :null => false
      t.string :fields, :null => false
      t.string :description
      t.integer :page_id, :null => false
      
      t.timestamps
    end
    
    add_index(:route_handlers, :page_id)
  end

  def self.down
    drop_table :route_handlers
  end
end
class CreateRouteHandlers < ActiveRecord::Migration
  def self.up
    create_table :route_handlers do |t|
      t.string :url, :null => false
      t.string :fields, :null => false
      t.text :transformation_rules
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :route_handlers
  end
end
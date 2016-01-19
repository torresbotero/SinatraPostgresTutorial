class CreateItem < ActiveRecord::Migration
  def up
  	create_table :items do |t|
  		t.string :name
  		t.string :price
  		t.string :description
  		t.timestamps null: false
  	end
  end

  def down
  	drop_table :items
  end
end

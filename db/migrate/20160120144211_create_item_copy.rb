class CreateItemCopy < ActiveRecord::Migration
  def change
  	create_table :item_copies do |t|
  		t.string :name
  		t.string :price
  		t.string :description
  		t.timestamps null: false
  	end
  end

  
end

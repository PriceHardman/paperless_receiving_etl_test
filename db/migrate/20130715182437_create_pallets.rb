class CreatePallets < ActiveRecord::Migration
  def change
    create_table :pallets do |t|
      t.integer :fr_number
      t.integer :line_id
      t.string :description
      t.date :receive_date
      t.integer :pallet_number
      t.integer :item_quantity
      t.integer :item_length
      t.integer :item_width
      t.integer :item_height
      t.string :transferred
      t.string :hazard_id
      t.string :deck_stow
      t.string :rate_class_tli
      t.string :secondary_description
      t.string :service_class_id
      t.string :oversize_yn

      t.timestamps
    end
  end
end

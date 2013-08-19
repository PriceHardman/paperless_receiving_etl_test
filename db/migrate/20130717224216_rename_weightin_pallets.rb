class RenameWeightinPallets < ActiveRecord::Migration
  change_table :pallets do |t|
    t.rename :gross_line_item_weight, :weight_per_item
  end
end

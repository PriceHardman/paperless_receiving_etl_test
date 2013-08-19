class AddGrossLineItemWeightToPallets < ActiveRecord::Migration
  def change
    add_column :pallets, :gross_line_item_weight, :integer
  end
end

class AddItemWeightToPallets < ActiveRecord::Migration
  def change
    add_column :pallets, :item_weight, :integer
  end
end

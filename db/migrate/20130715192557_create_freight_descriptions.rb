class CreateFreightDescriptions < ActiveRecord::Migration
  def change
    create_table :freight_descriptions do |t|
      t.string :freight_description
      t.string :description_category
      t.string :rate_class_tli
      t.string :rate_units

      t.timestamps
    end
  end
end

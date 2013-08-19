class Pallet < ActiveRecord::Base
  attr_accessible :deck_stow, :description, :fr_number,
                  :hazard_id, :item_height, :item_length,
                  :item_quantity, :item_width, :line_id,
                  :oversize_yn, :pallet_number, :rate_class_tli,
                  :receive_date, :secondary_description,
                  :service_class_id, :transferred


end

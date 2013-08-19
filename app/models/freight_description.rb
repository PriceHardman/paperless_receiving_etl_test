class FreightDescription < ActiveRecord::Base
  attr_accessible :description_category, :freight_description,
                  :rate_class_tli, :rate_units
end

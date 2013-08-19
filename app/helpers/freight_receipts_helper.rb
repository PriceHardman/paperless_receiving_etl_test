module FreightReceiptsHelper

  def pallet_data
    fields = {
        :item_quantity => "Qty",
        :weight_per_item => "Weight Per Item",
        :description => "Description",
        :item_length => "Length",
        :item_width => "Width",
        :item_height => "Height",
        :secondary_description => "Secondary Description"
    }

  end

  def freight_receipt_data
    fields = {
        :id => "Freight Receipt #",
        :booking_id => "Booking #",
        :sequence_no => "Booking Sequence #",
        :vessel_id => "Vessel",
        :voyage => "Voyage",
        :destination => "Destination",
        :dock_abbr => "Dock Code",
        :customer => "Customer",
        :consignee => "Consignee",
        :shipper => "Shipper",
        :customer_id => "Customer ID",
        :consignee_id => "Consignee ID",
        :shipper_id => "Shipper ID",
        :creation_date => "FR Creation Date",
        :create_time => "FR Creation Time"
    }
    fields
  end
end

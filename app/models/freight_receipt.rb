class FreightReceipt < InformixBackedModel
  set_dataset @@connection[:warehouse_tran]

  dataset_module do
    def search(search) #method that performs search on all table columns based on input in box in index.html.erb
      case
        when search.match(/^\D+/) #if there are no digits in the search string
          #wildcard filters using Sequel.like on:
          # vessel_id, destination_id, destination, consignee_id, consignee, shipper, po_id,vendor_name
          #return records where search wildcard matches any of those fields
          result = where(Sequel.like(:vessel_id,"%#{search.upcase}%"))
          [:destination_id,:destination,
           :consignee_id,:consignee,:shipper,:po_id,:vendor_name].each do |column|
            result = result.or(Sequel.like(column,"%#{search.upcase}%"))
          end
          result = result.or(Sequel.join([:vessel_id,:voyage]).like("%#{search.upcase}%"))
          result
        else
          #assume we're looking for a booking_id, sequence_no, id (fr#), customer_id, or voyage (i.e. numeric field).
          #return records where search equals any of those fields. Informix forbids wildcard searches on numeric fields.
          result = where(:booking_id => search)
          [:sequence_no,:id,:customer_id,:voyage].each do |column|
            result = result.or(column => search)
          end
          result
      end
    end
  end

  def pallets
    Pallet.where(:fr_number => self.id)
  end
end

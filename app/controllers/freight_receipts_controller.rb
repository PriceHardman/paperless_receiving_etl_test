class FreightReceiptsController < ApplicationController
  respond_to :html, :json, :js

  def index
    #This method will show all pending freight receipts (those with no pallets)
    #Users can also search for freight receipts by name
    today = Time.now.strftime("%m/%d/%Y")
    one_week_ago = (Time.now-(7*24*3600)).strftime("%m/%d/%Y")
      #if no search parameters, get today's freight receipts
      @freight_receipts = FreightReceipt.filter(
          'creation_date >= ?',today).filter(
          'north_south = ?',"N").reverse_order(
          :id).limit(20)

    respond_to do |format|
      format.html #index.html.erb
      format.json do
        @freight_receipts = FreightReceipt.filter(
            'creation_date >= ?',one_week_ago).filter(
            'north_south = ?',"N").search(params[:search]).reverse_order(:id).limit(50)
        render :json => @freight_receipts
      end
    end
  end

  def show
    @freight_receipt = FreightReceipt[params[:id]]
  end
end
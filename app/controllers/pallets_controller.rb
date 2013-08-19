class PalletsController < ApplicationController
  def new
    @freight_receipt = FreightReceipt[params[:freight_receipt_id]]
    @pallet = @freight_receipt.pallets.new
  end
end
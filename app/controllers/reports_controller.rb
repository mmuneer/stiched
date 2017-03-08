class ReportsController < ApplicationController
  def successful_clearances
    @clearance_items = Item.clearanced.by_batch(params[:batch_id])
  end
end
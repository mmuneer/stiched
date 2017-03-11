class ClearanceBatchesController < ApplicationController

  def index
    @clearance_batches  = ClearanceBatch.all
  end

  def batch_process
    clearancing_status = ClearancingService.new(Clearance::Processors::BatchProcessor.new,
                                                Clearance::Validators::BatchValidator.new,
                                                params[:csv_batch_file].tempfile).process
    clearance_batch    = clearancing_status.clearance_batch
    alert_messages     = []
    if clearance_batch.persisted?
      flash[:notice]  = "#{clearance_batch.items.count} items clearanced in batch #{clearance_batch.id}"
    else
      alert_messages << "No new clearance batch was added"
    end

    if clearancing_status.errors.any?
      alert_messages << "#{clearancing_status.errors.count} item ids raised errors and were not clearanced"
      clearancing_status.errors.each {|error| alert_messages << error }
    end
    flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    redirect_to action: :index
  end

  def scan
    if params[:barcode].casecmp('done') == 0
      clearance_batch = ClearancingService.create_clearance_batch
      flash[:notice]  = "#{clearance_batch.items.count} items clearanced in batch #{clearance_batch.id}"
    else
      clearancing_status = ClearancingService.new(Clearance::Processors::Scanner.new,
                                                  Clearance::Validators::ScanValidator.new,
                                                  params[:barcode]).process

      if clearancing_status.success == true
        flash[:notice] = "Item #{clearancing_status.item_id} has been added to the clearance queue"
      else
        flash[:alert] = clearancing_status.message
      end
    end
    redirect_to action: :index
  end

end

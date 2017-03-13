require 'rails_helper'

describe ClearanceBatchesController do
  let(:items)         { 3.times.map { FactoryGirl.create(:item) } }
  describe '#index' do
    it 'returns all the clearance batches' do
      expect(ClearanceBatch).to receive(:all)

      get :index
    end

    it 'renders clearance_batches page' do
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe "#batch_process" do
    let(:file_name)     { generate_csv_file(items) }
    let(:uploaded_file) { Rack::Test::UploadedFile.new(file_name) }
    context 'no new batch creation' do
      it 'responds with appropriate message' do
        status = OpenStruct.new(
                  clearance_batch: ClearanceBatch.new,
                  item_ids_to_clearance: [],
                  errors: [])
        allow(ClearancingService).to receive_message_chain(:new, :process).and_return(status)

        post :batch_process, csv_batch_file: uploaded_file

        expect(flash[:alert]).to match('No new clearance batch was added')

      end
    end

    context 'new batch creation' do
      it 'responds with number of items clearanced for the batch' do
        batch = ClearanceBatch.new
        batch.items << items.first
        batch.save!
        status = OpenStruct.new(
            clearance_batch: batch,
            item_ids_to_clearance: [],
            errors: [])
        allow(ClearancingService).to receive_message_chain(:new, :process).and_return(status)

        post :batch_process, csv_batch_file: uploaded_file

        expect(flash[:notice]).to match("1 items clearanced in batch #{status.clearance_batch.id}")

      end
    end

    context 'batch creation with errors' do
      it 'creates appropriate error message' do
        status = OpenStruct.new(
            clearance_batch: ClearanceBatch.new,
            item_ids_to_clearance: [],
            errors: ["Error"])

        allow(ClearancingService).to receive_message_chain(:new, :process).and_return(status)

        post :batch_process, csv_batch_file: uploaded_file

        expect(flash[:alert]).to match('1 item ids raised errors and were not clearanced')
      end

      it 'adds error to alert messages' do
        status = OpenStruct.new(
            clearance_batch: ClearanceBatch.new,
            item_ids_to_clearance: [],
            errors: ["Error"])

        allow(ClearancingService).to receive_message_chain(:new, :process).and_return(status)

        post :batch_process, csv_batch_file: uploaded_file

        expect(flash[:alert]).to match("error")
      end
    end

    it 'renders clearance_batches page' do
      post :batch_process, csv_batch_file: uploaded_file

      expect(response).to redirect_to('/clearance_batches')
    end
  end

  describe '#scan' do
    it 'renders clearance_batches page' do
      post :scan, barcode: 'done'

      expect(response).to redirect_to('/clearance_batches')
    end

    context 'finished scanning all barcodes' do
      it 'responds with appropriate message' do
        batch = ClearanceBatch.new
        batch.items << items.first
        batch.save!
        allow(ClearancingService).to receive(:create_clearance_batch_for_scanned_items).and_return(batch)

        post :scan, barcode: 'done'

        expect(flash[:notice]).to match("1 items clearanced in batch #{batch.id}")
      end

    end

    context 'scanning barcodes' do
      context 'success' do
        it 'responds with appropriate message' do
          item = items.first
          item.update_attributes(barcode: item.id.to_s)
          post :scan, barcode: item.id.to_s

          expect(flash[:notice]).to match("Item #{item.id} has been added to the clearance queue")
        end
      end

      context 'failure' do
        it 'responds with appropriate message' do
          status =  OpenStruct.new(
              item_id: nil,
              success: false,
              message: "error")

          allow(ClearancingService).to receive_message_chain(:new, :process).and_return(status)

          post :scan, barcode: items.first.id.to_s

          expect(flash[:alert]).to match("error")

        end
      end
    end


  end


end
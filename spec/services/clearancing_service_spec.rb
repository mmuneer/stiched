require 'rails_helper'

describe ClearancingService do
  let(:items)         { 5.times.map { FactoryGirl.create(:item) } }
  let(:file_name)     { generate_csv_file(items) }
  let(:uploaded_file) { Rack::Test::UploadedFile.new(file_name) }
  let(:processor) { Clearance::Processors::BatchProcessor.new }
  let(:validator) { Clearance::Validators::BatchValidator.new }

  before(:each) do
    @service = ClearancingService.new(processor,
                                      validator,
                                      uploaded_file)
  end

  context 'initialize' do
    it 'sets processor type and data' do
      expect(@service.processor.class).to eql(Clearance::Processors::BatchProcessor)
      expect(@service.validator.class).to eql(Clearance::Validators::BatchValidator)
      expect(@service.data).to eql(uploaded_file)
    end
  end

  context 'process' do
    it 'invokes appropriate processor' do
      expect(processor).to receive(:process).with(uploaded_file, validator)

      @service.process
    end
  end

  context 'create_clearance_batch_for_scanned_items' do
    before(:each) do
      items.each  { |item| item.update_attributes(status: 'clearanced') }
    end
    it 'creates a new clearance batch' do
      expect(ClearancingService.create_clearance_batch_for_scanned_items).to eq(ClearanceBatch.last)
    end
    it 'adds all scanned items to clearance batch' do
      batch = ClearancingService.create_clearance_batch_for_scanned_items

      expect(batch.items).to eq(items)
    end
  end
end

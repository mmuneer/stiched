require 'rails_helper'

describe ClearancingService do
  let(:items)         { 5.times.map { FactoryGirl.create(:item) } }
  let(:file_name)     { generate_csv_file(items) }
  let(:uploaded_file) { Rack::Test::UploadedFile.new(file_name) }

  before(:each) do
    @service = ClearancingService.new(:BatchProcessor, uploaded_file)
  end

  context 'initialize' do
    it 'sets processor type and data' do
      expect(@service.processor).to eql(Clearance::Processors::BatchProcessor)
      expect(@service.data).to eql(uploaded_file)
    end
  end

  context 'process' do
    it 'invokes appropriate processor' do
      expect(Clearance::Processors::BatchProcessor).to receive(:process).with(uploaded_file)

      @service.process
    end
  end
end

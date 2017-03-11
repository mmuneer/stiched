require 'rails_helper'

describe Clearance::Processors::Scanner do
  subject(:scanner) { Clearance::Processors::Scanner.new }
  let(:item)        { FactoryGirl.create(:item) }
  let(:validator) { Clearance::Validators::ScanValidator.new }
  let(:barcode) { item.barcode }
  let(:invalid_barcode) {3}
  let(:clearancing_status) { OpenStruct.new(item_id: nil, success: false, message: nil) }

  describe 'process function' do
    context 'failure' do
      it 'returns error_status' do
        message = "Barcode #{invalid_barcode} is not valid"

        expect(scanner.process(invalid_barcode, validator).message).to eql(message)
      end
    end

    context 'success' do
      it 'clearances item' do
        scanner.process(barcode, validator)

        expect(Item.find(item.id).status).to eql("clearanced")
      end

      it 'returns success_status' do
        expect(scanner.process(barcode, validator).success).to eql(true)
      end
    end
  end
end


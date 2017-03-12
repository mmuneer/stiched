require 'rails_helper'

describe Clearance::Validators::BatchValidator do
  let(:items)  { 5.times.map { FactoryGirl.create(:item) } }

  before(:each) do
    @validator = Clearance::Validators::BatchValidator.new
  end

  describe 'error function' do
    it 'returns false if no error is found' do
      expect(@validator.error(items.first.id)).to eq(false)
    end

    context 'ID check conditional' do

      it 'returns Item id  not valid if id equals 0' do
        expect(@validator.error(0)).to eq('Item id 0 is not valid')
      end

      it 'returns Item id  not valid if id is not an integer' do
        expect(@validator.error(items.first.id.to_s)).to eq("Item id #{items.first.id} is not valid")
      end

      it 'returns Item id  not valid if id is blanks' do
        expect(@validator.error("")).to eq('Item id  is not valid')
      end
    end

    it 'returns item id not found if item does not exist in data store' do
      expect(@validator.error(items.last.id + 1)).to eq("Item id #{items.last.id + 1} could not be found")
    end

    it 'returns item id could not clearanced if item is not sellable' do
      item = items.first
      item.update_attributes(status: 'sold')

      expect(@validator.error(item.id)).to eq("Item id #{item.id} could not be clearanced")
    end
  end

end
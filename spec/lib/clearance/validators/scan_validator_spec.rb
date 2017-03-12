require 'rails_helper'

describe Clearance::Validators::ScanValidator do
  let(:item)  { FactoryGirl.create(:item)  }

  before(:each) do
    @validator = Clearance::Validators::ScanValidator.new
  end

  it 'returns error message when barcode is blank' do
    expect(@validator.error("")).to eql("Barcode  is not valid")
  end

  it 'returns error message when barcode is not a string' do
    expect(@validator.error(1)).to eql("Barcode 1 is not valid")
  end

  it 'returns error message when barcode is not found' do
    expect(@validator.error("2")).to eql("Barcode 2 could not be found")
  end

  it 'returns error when item is not sellable' do
    item.update_attributes(status: 'sold')
    barcode = Item.find(item.id).barcode
    expect(@validator.error(barcode)).to eql("Barcode #{barcode} could not be clearanced")
  end

  it 'returns false if no error is found' do
    expect(@validator.error(item.barcode)).to eql(false)
  end

end
require 'rails_helper'

describe Item do
  let(:wholesale_price) { 100 }
  let(:item)  { FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: wholesale_price)) }
  let(:clearance_batch) {FactoryGirl.create(:clearance_batch)}
  let(:sellable_items) { 5.times.map { FactoryGirl.create(:item, status: 'sellable') } }
  let(:clearance_items) { 5.times.map { FactoryGirl.create(:item, status: 'clearanced', clearance_batch_id: clearance_batch.id) } }
  describe '#perform_clearance!' do
    before do
      item.clearance!
      item.reload
    end

    it 'marks the item status as clearanced' do
      expect(item.status).to eq('clearanced')
    end

    it 'sets the price_sold as 75% of the wholesale_price' do
      expect(item.price_sold).to eq(BigDecimal.new(wholesale_price) * BigDecimal.new('0.75'))
    end

  end

  describe '#sellable'  do
    it 'finds all the sellable items' do
      expect(Item.sellable).to eq(sellable_items)
    end
  end

  describe '#clearanced' do
    it 'finds all the clearanced items' do
      expect(Item.clearanced).to eq(clearance_items)
    end
  end

  describe '#by_batch' do
    it 'finds all the items for specified batch' do
      expect(Item.by_batch(clearance_batch.id)).to eq(clearance_items)
    end
  end
end

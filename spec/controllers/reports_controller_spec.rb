require 'rails_helper'

describe ReportsController do
  describe 'successful_clearances' do
    it 'renders successful_clearances page' do
      get :successful_clearances

      expect(response).to render_template(:successful_clearances)
    end

    it 'fetches all the clearancing items' do
      expect(Item).to receive_message_chain(:clearanced, :by_batch).with('1')

      get :successful_clearances, batch_id: '1'
    end
  end

end
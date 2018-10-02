require 'rails_helper'
require 'digest'

RSpec.describe Billing::ChargesController, type: :controller do
  render_views

  let!(:path) { create(:path) }

  describe "GET #show" do
    context "when charge is created" do
      it "responds with status 200 OK" do
        charge = create(:charge, :created)

        get :show, params: { id: charge.uid }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a charge is paid" do
      it "responds with status 200 OK" do
        charge = create(:charge, :paid)

        get :show, params: { id: charge.uid }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a charge is rejected" do
      it "responds with status 200 OK" do
        charge = create(:charge, :rejected)

        get :show, params: { id: charge.uid }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

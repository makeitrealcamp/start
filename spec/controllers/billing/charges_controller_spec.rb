# == Schema Information
#
# Table name: billing_charges
#
#  id             :integer          not null, primary key
#  uid            :string(50)
#  user_id        :integer
#  payment_method :integer          default("unknown")
#  status         :integer          default("created")
#  currency       :string(5)
#  amount         :decimal(, )
#  tax            :decimal(, )
#  tax_percentage :decimal(, )
#  description    :string
#  details        :hstore
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_billing_charges_on_user_id  (user_id)
#
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

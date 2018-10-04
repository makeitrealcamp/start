require 'rails_helper'

RSpec.describe Billing::PayuController, type: :controller do
  describe "POST #confirm" do
    context "when transaction is approved" do
      it "responds with status 200 OK and updates charge" do
        charge = create(:charge, :created)

        post :confirm, params: {
          state_pol: "4",
          response_code_pol: "1",
          response_message_pol: "APPROVED",
          payment_method_type: "4",
          merchant_id: ENV['PAYU_MERCHANT_ID'],
          reference_sale: charge.uid,
          currency: "COP",
          value: charge.amount,
          sign: confirm_signature(ENV['PAYU_MERCHANT_ID'], charge.uid, charge.amount, "COP", 4)
        }

        expect(response).to have_http_status(:ok)

        charge.reload
        expect(charge.status).to eq("paid")
        expect(charge.payment_method).to eq("pse")
      end
    end

    context "when transaction is declined" do
      it "responds with status 200 OK and updates charge" do
        charge = create(:charge, :created)

        post :confirm, params: {
          state_pol: "6",
          response_code_pol: "5",
          response_message_pol: "ENTITY_DECLINED",
          payment_method_type: "2",
          merchant_id: ENV['PAYU_MERCHANT_ID'],
          reference_sale: charge.uid,
          currency: "COP",
          value: charge.amount,
          sign: confirm_signature(ENV['PAYU_MERCHANT_ID'], charge.uid, charge.amount, "COP", 6)
        }

        expect(response).to have_http_status(:ok)

        charge.reload
        expect(charge.status).to eq("rejected")
        expect(charge.payment_method).to eq("credit_card")
      end
    end
  end
end

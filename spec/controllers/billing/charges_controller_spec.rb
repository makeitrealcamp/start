require 'rails_helper'
require 'digest'

RSpec.describe Billing::ChargesController, type: :controller do
  render_views

  let!(:path) { create(:path) }

  describe "GET #show" do
    context "when charge is created" do
      it "responds with status 200 OK" do
        ENV['REACT_REDUX_PATH_ID'] = path.id.to_s
        charge = create(:charge, :created_deposit)

        get :show, params: { id: charge.uid }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a charge is paid" do
      it "responds with status 200 OK" do
        charge = create(:charge, :paid_credit_card)

        get :show, params: { id: charge.uid }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a charge is rejected" do
      it "responds with status 200 OK" do
        charge = create(:charge, :rejected_credit_card)

        get :show, params: { id: charge.uid }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST #confirm" do
    context "when a charge is valid" do
      it "creates the user" do
        charge = create(:charge, :created_credit_card)

        ENV['REACT_REDUX_PATH_ID'] = path.id.to_s
        ENV['EPAYCO_SECRET'] = "12345"
        data = {
          x_cust_id_cliente: "9876",
          x_id_invoice: charge.uid,
          x_ref_payco: "1234",
          x_amount: "100",
          x_currency_code: "COP",
          x_bank_name: "Banco de Pruebas",
          x_cardnumber: "457562*******0326",
          x_response: "Aceptada",
          x_approval_code: "1111",
          x_transaction_id: "1234",
          x_transaction_date: "2017-02-16 14:52:35",
          x_cod_response: 1,
          x_franchise: "VISA",
          x_signature: Digest::SHA256.hexdigest("9876^12345^1234^1234^100^COP")
        }

        expect { post :confirm, params: data }.to change(User, :count).by(1)
      end
    end
  end
end

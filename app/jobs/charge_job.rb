class ChargeJob < ActiveJob::Base
  queue_as :default

  def perform(charge_id)
    return unless Billing::Charge.exists?(charge_id)

    charge = Billing::Charge.find(charge_id)
    charge.update(attempts: charge.attempts + 1)

    begin
      unless charge.epayco_customer_id
        response = create_customer(charge)
        result = JSON.parse(response.body)
        logger.info result.inspect
        if !(result["success"] || result["status"])
          charge.update(status: :error, error_message: result["message"])
        else
          customer_id = result["data"]["customerId"]
          charge.update(epayco_customer_id: customer_id)
        end
      end

      if charge.epayco_customer_id
        response = create_charge(charge)

        result = JSON.parse(response.body)
        puts logger.info
        if !result["success"]
          charge.update(status: :error, error_message: "#{result["message"]}. #{result["data"]["description"]}")
        else
          if result["data"]["estado"] == "Aceptada"
            charge.update(status: :paid, epayco_ref: result["data"]["ref_payco"])

            user = User.where(email: charge.email).take
            unless user
              user = User.create!(email: charge.email, first_name: charge.first_name, last_name: charge.last_name, status: :created, account_type: :paid_account, access_type: :password)
            end
            path = Path.find(ENV['REACT_REDUX_PATH_ID'])
            user.paths << path

            ConvertLoop.people.create_or_update(email: charge.email, add_tags: ["React Redux"])

          elsif result["data"]["estado"] == "Rechazada" || result["data"]["estado"] == "Fallida"
            charge.update(status: :rejected, error_message: result["data"]["respuesta"])

            UserMailer.charge_rejected(charge).deliver_later
          end
        end
      end
    rescue Net::ReadTimeout
      charge.update(status: :error, error_message: "Error en la conexión con la pasarela de pagos: Net::ReadTimeout")
    rescue Exception => e
      stack_trace = e.backtrace.join("\n")
      charge.update(status: :error, error_message: "Error desconocido: \n\n\t#{e.message}", stack_trace: stack_trace)
    end
  end

  def create_customer(charge)
    HTTParty.post("https://api.secure.payco.co/payment/v1/customer/create",
        body: {
          public_key: "1d0ebb3e6d2fc998f7cd8b289d606eda",
          token_card: charge.card_token,
          name: charge.customer_name,
          email: charge.customer_email,
          phone: charge.customer_mobile,
          default: true
        }.to_json,
        headers: { 'Content-Type' => 'application/json'})
  end

  def create_charge(charge)
    attrs = {
      public_key: "1d0ebb3e6d2fc998f7cd8b289d606eda",
      token_card: charge.card_token,
      customer_id: charge.epayco_customer_id,
      doc_type: charge.customer_id_type,
      doc_number: charge.customer_id,
      name: charge.first_name,
      last_name: charge.last_name,
      email: charge.email,
      ip: charge.ip,
      bill: charge.uid,
      description: charge.description,
      value: "#{charge.amount}",
      tax: "#{charge.tax}",
      tax_base: "#{charge.amount - charge.tax}",
      currency: "COP",
      dues: "12"
    }

    attrs[:test] = "TRUE" if Rails.env.development?

    HTTParty.post("https://api.secure.payco.co/payment/v1/charge/create",
        body: attrs.to_json,
        headers: { 'Content-Type' => 'application/json'})
  end
end

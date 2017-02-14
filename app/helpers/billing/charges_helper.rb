module Billing::ChargesHelper
  def payment_method(charge)
    if charge.deposit?
      "Consignación o Transferencia"
    elsif charge.credit_card?
      "Tarjeta de Crédito"
    else
      "Otro"
    end
  end

  def charge_header_tag(charge)
    class_name, title = if @charge.paid?
      ["success", "TRANSACCIÓN EXITOSA"]
    elsif @charge.created? && @charge.deposit?
      ["info", "PENDIENTE DE PAGO"]
    elsif @charge.created? && @charge.credit_card?
      ["warning", "EN VALIDACIÓN"]
    elsif @charge.error?
      ["danger", "ERROR EN LA TRANSACCIÓN"]
    elsif @charge.rejected?
      ["danger", "TRANSACCIÓN RECHAZADA"]
    end

    content_tag 'div', "<strong>#{title}</strong>".html_safe, class: "alert alert-#{class_name}"
  end
end

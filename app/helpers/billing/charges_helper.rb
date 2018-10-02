module Billing::ChargesHelper
  def charge_header_tag(charge)
    class_name, title = if charge.paid?
      ["success", "TRANSACCIÓN EXITOSA"]
    elsif charge.created? || charge.pending?
      ["info", "PENDIENTE POR CONFIRMAR"]
    elsif charge.error?
      ["danger", "ERROR EN LA TRANSACCIÓN"]
    elsif charge.rejected?
      ["danger", "TRANSACCIÓN RECHAZADA"]
    end

    content_tag 'div', "<strong>#{title}</strong>".html_safe, class: "alert alert-#{class_name}"
  end
end

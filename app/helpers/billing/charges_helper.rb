module Billing::ChargesHelper
  def charge_header_tag(charge)
    class_name, title = if (charge == "complete" || charge.paid?)
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

  def charge_stripe_status_tag(charge)
    class_name, title = if charge == "complete"
      ["success", "TRANSACCIÓN EXITOSA"]
    elsif charge == "incomplete"
      ["info", "PENDIENTE POR CONFIRMAR"]
    elsif charge == "incomplete_expired"
      ["danger", "TRANSACCIÓN EXPIRADA"]
    elsif charge == "canceled"
      ["danger", "TRANSACCIÓN CANCELADA"]
    end
    content_tag 'div', "<strong>#{title}</strong>".html_safe, class: "alert alert-#{class_name}" 
  end

end

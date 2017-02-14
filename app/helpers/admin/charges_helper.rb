module Admin::ChargesHelper
  def admin_payment_method(charge)
    if charge.deposit?
      "Depósito"
    elsif charge.credit_card?
      "Tarjeta de Crédito"
    else
      "Otro"
    end
  end

  def admin_status(charge)
    if charge.created? && charge.deposit?
      "Pendiente de Pago"
    elsif charge.created? && charge.credit_card?
      "En Validación"
    elsif charge.paid?
      "Pagada"
    elsif charge.rejected?
      "Rechazada"
    elsif charge.error?
      "Error"
    else
      "Desconocido"
    end
  end
end

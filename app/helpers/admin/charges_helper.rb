module Admin::ChargesHelper
  def admin_status(charge)
    if charge.created?
      "Pendiente por confirmar"
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

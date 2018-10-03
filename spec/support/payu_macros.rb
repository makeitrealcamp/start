module PayuMacros
  def confirm_signature(merchant_id, transaction_id, value, currency, state)
    new_value = sprintf("%.1f", BigDecimal(value))
    msg = "#{ENV['PAYU_API_KEY']}~#{merchant_id}~#{transaction_id}~#{new_value}~#{currency}~#{state}"
    Digest::MD5.hexdigest(msg)
  end
end

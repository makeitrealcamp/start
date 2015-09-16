module ApplicationMacros

  def handle_confirm
    page.execute_script 'window.confirm = function () { return true }'
  end
end

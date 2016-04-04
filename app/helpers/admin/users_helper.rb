module Admin::UsersHelper
  def full_name(user)
    name = "#{user.first_name} #{user.last_name}"
    name.blank? ? "Sin Nombre" : name
  end

  def status(user)
    statuses = { created: "Sin activar", active: "Activo", suspended: "Suspendido" }
    statuses[user.status.to_sym] || "Indefinido"
  end

  def account_type_filter_link(opts)
    classes = ["btn","btn-default","account-type-filter-btn"]
    classes += ["active","btn-primary"] if opts[:active] == true
    %Q(<a class="#{classes.join(" ")}"
      href="#{opts[:url]}"
      data-account-type-id="#{opts[:id]}">#{opts[:text]}</a>).html_safe
  end
end

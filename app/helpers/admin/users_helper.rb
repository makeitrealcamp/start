module Admin::UsersHelper
  def account_type_filter_link(opts)
    classes = ["btn","btn-default","account-type-filter-btn"]
    classes += ["active","btn-primary"] if opts[:active] == true
    %Q(<a class="#{classes.join(" ")}"
      href="#{opts[:url]}"
      data-account-type-id="#{opts[:id]}">#{opts[:text]}</a>).html_safe
  end
end

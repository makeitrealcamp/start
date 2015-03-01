class DashboardController < ApplicationController
  before_action :private_access

  QUOTES = [
    { text: "Nuestra mayor debilidad radica en darnos por vencidos. La forma más segura de triunfar es siempre intentarlo una vez más.", author: "Thomas A. Edison" },
    { text: "No importa qué tan lento vayas siempre y cuando no te detengas.", author: "Confucio" },
    { text: "Para poder triunfar, primero debemos creer que podemos.", author: "Og Mandino" },
    { text: "Nunca estás muy viejo para trazar una nueva meta o soñar un nuevo sueño.", author: "C. S. Lewis" },
  ]

  def index
    @quote = QUOTES.sample
    @courses = Course.all.rank(:row)
  end
end

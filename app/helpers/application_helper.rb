module ApplicationHelper
  class HtmlWithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", language, sha].join('-') do
        lexer = Pygments::Lexer[language] || Pygments::Lexer['text']
        lexer.highlight(code)
      end
    end
  end

  def markdown(text, opts={})
    renderer = HtmlWithPygments.new({ hard_wrap: true, filter_html: false }.merge(opts))
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }

    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  def simple_markdown(text, opts={})
    renderer = Redcarpet::Render::HTML.new({ hard_wrap: true, filter_html: false }.merge(opts))
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }

    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  def embedded_video(src, opts = {}, html = {})
    user = opts[:user]
    uri = URI(src)
    id_video = src.split('/').last

    html[:src] ||= uri
    html[:allowtransparency] ||= true
    html[:frameborder] ||= "0"
    html[:scrolling] ||= "no"
    html[:allowfullscreen] ||= true
    html[:mozallowfullscreen] ||= true
    html[:webkitallowfullscreen] ||= true
    html[:oallowfullscreen] ||= true
    html[:msallowfullscreen] ||= true
    content_tag(:iframe, nil, html)
  end

  def genderize(male, female, user=current_user)
    user.gender == "female" ? female : male
  end

  def quote
    random_quote = [
      { text: "Nuestra mayor debilidad radica en darnos por vencidos. La forma más segura de triunfar es siempre intentarlo una vez más.", author: "Thomas A. Edison" },
      { text: "No importa qué tan lento vayas siempre y cuando no te detengas.", author: "Confucio" },
      { text: "Para poder triunfar, primero debemos creer que podemos.", author: "Og Mandino" },
      { text: "Nunca estás muy viejo para trazar una nueva meta o soñar un nuevo sueño.", author: "C. S. Lewis" },
    ].sample

    content_tag(:blockquote) do
      [
        random_quote[:text],
        content_tag(:span," - #{random_quote[:author]}",class:"author")
      ].join(' ').html_safe
    end

  end

  def facebook_button(opts={})
    if Rails.env == "development"
      # In development, we will share always the MIR page
      # because Facebook needs to crawl data from a public website
      opts[:url] = "http://makeitreal.camp"
    end
    super(opts)
  end

  def alert_classes(type)
    return "alert-success alert-notice" if ["notice","success"].include? type.to_s
    return "alert-error alert-danger" if ["error","danger"].include? type.to_s
    return "alert-#{type.to_s}"
  end

  def timestamp(date)
    date.to_datetime.strftime("%Q")
  end

  # data to show the progress chart of a user
  def progress_data(user)
    total_points = 0

    start = Date.current
    if(first_point = user.points.order(:created_at).first)
      start = first_point.created_at
    end

    level = Level.order(:required_points).second
    curr = 0
    data = (start.to_date..(Date.current+1.day)).map do |day|
      { date: day, points: 0 }
    end

    user.points.order(:created_at).each do |point|

      day = point.created_at.beginning_of_day

      while data[curr][:date] != day
        curr+=1
        data[curr][:points] = data[curr-1][:points]
      end

      total_points += point.points

      data[curr][:points] = total_points
      while level && total_points > level.required_points
        data[curr][:level_upgrade] = level.name
        level = level.next
      end
    end

    curr+=1
    while curr < data.length
      data[curr][:points] = data[curr-1][:points]
      curr+=1
    end

    "[" + data.map do |day|
      date = day[:date]
      points = day[:points]
      ret = "{ x: new Date(#{date.year}, #{date.month-1}, #{date.day}), y: #{points}"
      if day[:level_upgrade]
        ret += ", indexLabel: '#{day[:level_upgrade]}'"
      end
      ret += " }"
    end.join(",") + "]"
  end

  def sha1(text)
    SHA1.encode(text)
  end

  def countries_options(selected="")
    options_for_select([
      ["País de residencia *", ""],
      ["Argentina", "AR", { data: { code: "54" } }],
      ["Bolivia", "BO", { data: { code: "591" } }],
      ["Chile", "CL", { data: { code: "56" } }],
      ["Colombia", "CO", { data: { code: "57" } }],
      ["Costa Rica", "CR", { data: { code: "506" } }],
      ["Ecuador", "EC", { data: { code: "593" } }],
      ["El Salvador", "SV", { data: { code: "503" } }],
      ["España", "ES", { data: { code: "34" } }],
      ["Estados Unidos", "US", { data: { code: "1" } }],
      ["Guatemala", "GT", { data: { code: "502" } }],
      ["Honduras", "HN", { data: { code: "504" } }],
      ["México", "MX", { data: { code: "52" } }],
      ["Nicaragua", "NI", { data: { code: "505" } }],
      ["Panamá", "PA", { data: { code: "507" } }],
      ["Paraguay", "PY", { data: { code: "595" } }],
      ["Perú", "PE", { data: { code: "51" } }],
      ["Puerto Rico", "PR", { data: { code: "1" } }],
      ["República Dominicana", "DO", { data: { code: "1" } }],
      ["Uruguay", "UY", { data: { code: "598" } }],
      ["Venezuela", "VE", { data: { code: "58" } }],
    ], selected)
  end

  def has_admin_access?(role)
    (signed_in? && current_user.is_admin?) || (current_admin && current_admin.has_role?(role))
  end

end

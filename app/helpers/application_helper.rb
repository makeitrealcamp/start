module ApplicationHelper
  class HtmlWithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", language, sha].join('-') do
        Pygments.highlight(code, lexer: language)
      end
    end
  end

  def markdown(text,opts={})
    renderer = HtmlWithPygments.new({hard_wrap: true, filter_html: false}.merge(opts))
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

  def embedded_video(src,opts = {}, html = {})
    user = opts[:user]
    uri = URI(src)
    id_video = src.split('/').last

    if uri.host == "fast.wistia.net"
      id_video = src.split('/').last
      content_tag :div do
        content_tag(:div, nil , id: "wistia_#{id_video}", class: "video-wistia") +
        javascript_include_tag("//fast.wistia.com/assets/external/E-v1.js") +
        javascript_tag("Wistia.embed('#{id_video}', { trackEmail: '#{user.email}' });")
      end
    else
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

    start = [user.activated_at || Date.current,user.points.order(:created_at).first.created_at || Date.current].min

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

end

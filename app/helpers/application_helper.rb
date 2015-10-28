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
    start = user.activated_at || Date.current

    total_points = 0
    level = Level.order(:required_points).second

    ret = "["
    (start.to_date..Date.current).map.with_index do |date, i|
      total_points += user.points.where(created_at: date.beginning_of_day..date.end_of_day).sum(:points)
      ret += "{ x: new Date(#{date.year}, #{date.month}, #{date.day}), y: #{total_points}"
      if level && total_points > level.required_points
        level = level.next
        ret += ", indexLabel: '#{level.name}'"
      end
      ret += " },"
    end
    ret = ret.chomp if ret.end_with?(",")
    ret += "]"
  end
end

module ApplicationHelper
  class HtmlWithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", language, sha].join('-') do
        Pygments.highlight(code, lexer: language)
      end
    end
  end

  def markdown(text)
    renderer = HtmlWithPygments.new(hard_wrap: true, filter_html: true)
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

  def embedded_video(src,opts = {})
    opts[:src] ||= src
    opts[:allowtransparency] ||= true
    opts[:frameborder] ||= "0"
    opts[:scrolling] ||= "no"
    opts[:allowfullscreen] ||= true
    opts[:mozallowfullscreen] ||= true
    opts[:webkitallowfullscreen] ||= true
    opts[:oallowfullscreen] ||= true
    opts[:msallowfullscreen] ||= true
    content_tag(:iframe,nil,opts)
  end

end

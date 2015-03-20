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

  def progress_bar(opts = {})
    opts[:type] ||= :success
    opts[:progress] ||= 0
    opacity = (opts[:progress].to_i/20*2).to_f/10

    %Q(
    <div class="progress">
      <div class="progress-bar progress-bar-#{opts[:type].to_s}"
        role="progressbar"
        style="width: #{opts[:progress].to_s}%;opacity:#{opacity}">
      </div>
    </div>).html_safe

  end

end

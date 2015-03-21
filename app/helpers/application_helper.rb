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
    type = (opts[:type] || "success").to_s
    progress = (opts[:progress] || 1).to_f

    opacity = 0.2
    diff = 1.0
    [0.2,0.4,0.6,0.8,1.0].each do |o|
      if (progress-o).abs < diff
        diff = (progress-o).abs
        opacity = o
      end
    end

    %Q(
    <div class="progress">
      <div class="progress-bar progress-bar-#{type}"
        role="progressbar"
        style="width: #{(progress*100).round(2)}%;opacity:#{opacity}">
      </div>
    </div>).html_safe

  end

end

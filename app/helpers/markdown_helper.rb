module MarkdownHelper

  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      no_intra_emphasis: true, 
      fenced_code_blocks: true,  
      disable_indented_code_blocks: true,
      autolink: true,
      tables: true)

    return markdown.render(text).html_safe
  end

end

# Graphviz
module GraphTemplate

  class Graphviz < ::ActionView::TemplateHandler
    MODECONFIG = {:directed => :dot, :undirected => :neato, :radial => :twopi, :circular => :circo, :undirected2 => :fdp}

    def self.call(template)
      "#{name}.new(self).render(template, local_assigns)"
    end

    def initialize(view = nil)
      @view = view
    end

    def render(template, local_assigns)
      source = template.source
      tpl = @view.render(:inline => source, :layout => false, :type => :erb)
      @view.controller.response.content_type ||= Mime::PNG
      @view.controller.headers['Content-Disposition'] = 'inline'
      format = (@view.params[:format] || :png).to_sym
      #format = :jpeg if format == :jpg
      mode = :directed
      gp = IO::popen("#{MODECONFIG[mode]} -q -T#{format}", "w+")
      gp << tpl
      gp.flush
      gp.close_write
      buf = ""
      gp.read(nil, buf)
      gp.close_read
      buf
    end

  end

end

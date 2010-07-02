# Graphviz
module GraphTemplate

  class Graphviz < ::ActionView::TemplateHandler
    LAYOUTS = [:dot, :neato, :twopi, :circo, :fdp, :sfdp]
    FORMATS = [:png, :cmapx, :svg, :gif, :vml, :pdf, :plain, :ps]

    def self.call(template)
      "#{name}.new(self).render(template, local_assigns)"
    end

    def initialize(view = nil)
      @view = view
    end

    def render(template, local_assigns)
      source = template.source
      tpl = @view.render(:inline => source, :locals => local_assigns, :layout => false, :type => :erb)
      return tpl if local_assigns[:erb]
      #@view.controller.response.content_type ||= Mime::PNG
      #@view.controller.headers['Content-Disposition'] = 'inline'
      format = tpl.scan(/\/\*!format=(.+?)\*\//i)
      format = (format.size > 0 ? format.last[0] : (@view.params[:format] || :png)).to_sym
      #for test
      return tpl if format == :rdot 
      raise(ArgumentError, "Format must in #{FORMATS.inspect}") unless FORMATS.include?(format)
      #Layout can be set by graph attr.
      gp = IO::popen("dot -q -T#{format}", "w+")
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

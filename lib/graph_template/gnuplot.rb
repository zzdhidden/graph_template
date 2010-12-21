# Gnuplot
module GraphTemplate

  class Gnuplot < ::ActionView::TemplateHandler

    def self.call(template)
      "#{name}.new(self).render(%q{#{template.source}}, local_assigns)"
    end

    def initialize(view = nil)
      @view = view
    end

    def render(source, local_assigns)
      tpl = @view.controller.render(:inline => source, :layout => false, :type => :erb)
      @view.controller.response.content_type ||= Mime::PNG
      @view.controller.headers['Content-Disposition'] = 'inline'
      gp = IO::popen('gnuplot', "r+")
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

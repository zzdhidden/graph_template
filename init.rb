# Include hook code here
Mime::Type.register_alias "image/png", :png unless Mime.const_defined?(:PNG)
Mime::Type.register_alias "image/gif", :gif unless Mime.const_defined?(:GIF)
Mime::Type.register_alias "image/jpeg", :jpg unless Mime.const_defined?(:JPG)
Mime::Type.register_alias "image/svg+xml", :svg unless Mime.const_defined?(:SVG)

require 'graph_template'

ActionView::Template.register_template_handler 'rplt', GraphTemplate::Gnuplot
ActionView::Template.register_template_handler 'rgnuplot', GraphTemplate::Gnuplot
ActionView::Template.register_template_handler 'rdot', GraphTemplate::Graphviz

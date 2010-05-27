require 'erb'
require 'cgi'

# FIXME this is a direct port of the TM one and refers to TM assets. We need to not do so!
HTML_TEMPLATE = <<-HTML
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
  "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <meta http-equiv="Content-type" content="text/html; charset=utf-8">
  <title><%= window_title %></title>
  <% bundle_styles.each { |style| %>
    <link rel="stylesheet" href="file://<%= bundle_support %>/themes/<%= style %>/css/style.css"   type="text/css" charset="utf-8" media="screen">
    <link rel="stylesheet" href="file://<%= bundle_support %>/themes/<%= style %>/css/print.css"   type="text/css" charset="utf-8" media="print">
  <% } %>
  <%= html_head %>
</head>
<body id="tm_webpreview_body" class="<%= html_theme %>">
  <div id="tm_webpreview_header">
    <img id="gradient" src="file://<%= theme_path %>/images/header.gif" alt="header">
    <p class="headline"><%= page_title %></p>
    <p class="type"><%= sub_title %></p>
    <img id="teaser" src="file://<%= theme_path %>/images/teaser.png" alt="teaser">
  </div>
  <div id="tm_webpreview_content" class="<%= html_theme %>">
HTML

def selected_theme
  'bright'
end

def html_head(options = { })
  window_title = options[:window_title] || options[:title]    || 'Window Title'
  page_title   = options[:page_title]   || options[:title]    || 'Page Title'
  sub_title    = options[:sub_title]    || ENV['TM_FILENAME'] || 'untitled'
  
  bundle_support = ENV['TM_BUNDLE_SUPPORT']
  
  common_styles  = ['default']
  bundle_styles  = bundle_support.nil? ? [] : ['default']
  
  common_styles.each { |style|
    next if style == 'default'
    bundle_styles << style if File.directory?(bundle_support + '/themes/' + style + "/css/")
  } unless bundle_support.nil?

  html_head    = options[:html_head]    || ''

  # if options[:fix_href] && File.exist?(ENV['TM_FILEPATH'].to_s)
  #   require "cgi"
  #   html_head << "<base href='tm-file://#{CGI.escape(ENV['TM_FILEPATH'])}'>"
  # end

  bundle_support = bundle_support.sub(/ /, '%20') unless bundle_support.nil?
  html_theme     = selected_theme  
  theme_path     = bundle_support + '/themes/default'

  ERB.new(HTML_TEMPLATE).result binding
end

# compatibility function
def html_header(tm_html_title, tm_html_lang = "", tm_extra_head = "", tm_window_title = nil, tm_fix_href = nil)
  puts html_head(:title => tm_html_title, :sub_title => tm_html_lang, :html_head => tm_extra_head,
                 :window_title => tm_window_title, :fix_href => tm_fix_href)
end

def html_footer
  puts <<-HTML
  </div>
</body>
</html>
HTML
end

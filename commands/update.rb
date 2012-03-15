require 'ruble'

command t(:update) do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_html
  cmd.input = :none
  cmd.invoke do |context|
    Dir.chdir ENV['TM_PROJECT_DIRECTORY']
    
    hg = ENV['TM_HG'] || "hg"
    require 'hg_helper'
    include HGHelper
    
    begin
      update = %x{#{hg} update -v 2>&1}
       
      make_head( 'Hg Update', ENV['TM_PROJECT_DIRECTORY'],
                  [ ENV['TM_BUNDLE_SUPPORT'] + '/Stylesheets/hg_style.css',
                    ENV['TM_BUNDLE_SUPPORT'] + '/Stylesheets/hg_log_style.css'] )
                    
      lines = update.split( "\n" )
      puts "<p><strong>" + lines[0] + "</strong></p>"
      puts "<ul>"
      lines[1].split( "," ).each do |files|
         puts "<li>" + files + "</li>"
      end
      puts "<ul>"
    
    ensure
       make_foot
    end
    
    context.project.refresh
    nil
  end
end

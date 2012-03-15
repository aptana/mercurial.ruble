require 'ruble'

command t(:incoming) do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_html
  cmd.input = :none
  cmd.invoke do |context|
    require 'stringio'
    require 'format_log'
    
    hg = ENV['TM_HG'] || "hg"
    Dir.chdir ENV['TM_PROJECT_DIRECTORY']
    hg_style = "#{ENV['TM_BUNDLE_SUPPORT']}/map-incoming.changelog"
    update = %x{#{hg} incoming -v --style "#{hg_style}" 2>&1}    
    format_log(:in, StringIO.new(update))
    nil
  end
end

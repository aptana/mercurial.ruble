require 'ruble'

command t(:outgoing) do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_html
  cmd.input = :none
  cmd.invoke do |context|
    require 'stringio'
    require 'format_log'
    
    hg = ENV['TM_HG'] || "hg"
    Dir.chdir ENV['TM_PROJECT_DIRECTORY']
    hg_style = "#{ENV['TM_BUNDLE_SUPPORT']}/map-log.changelog"
    update = %x{#{hg} outgoing -v --style "#{hg_style}" 2>&1}    
    format_log(:out, StringIO.new(update))
    nil
  end
end

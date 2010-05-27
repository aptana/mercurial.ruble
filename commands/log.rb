require 'ruble'

command 'Log' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_html
  cmd.input = :none
  cmd.invoke do |context|
    require 'stringio'
    require 'format_log'
    
    Dir.chdir ENV['TM_PROJECT_DIRECTORY']
    hg = ENV['TM_HG'] || 'hg'
    hg_limit = ''
    if ENV['TM_HG_LOG_LIMIT']
      log_limit = (ENV['TM_HG_LOG_LIMIT'] || '10').to_i
      hg_limit = "-l #{log_limit}"
    end
    hg_style = "#{ENV['TM_BUNDLE_SUPPORT']}/map-log.changelog"
    
    output = 
      if ENV['TM_SELECTED_FILES']
        `#{hg} log #{hg_limit} --style "#{hg_style}" "#{ENV['TM_FILEPATH']}" 2>&1`
      else
        `#{hg} log #{hg_limit} --style "#{hg_style}" #{ENV['TM_SELECTED_FILES']} 2>&1`
      end
    format_log(nil, StringIO.new(output))
    nil
  end
end

require 'ruble'

command 'Status' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_html
  cmd.input = :none
  cmd.invoke do |context|
    require 'format_status'
    require 'stringio'
    
    work_path = ENV['TM_PROJECT_DIRECTORY'] || ENV['TM_DIRECTORY']
    Dir.chdir work_path
    
    hg = ENV['TM_HG'] || "hg"
    output = %x{#{hg} status --debug #{ENV['TM_SELECTED_FILES']} 2>&1}
    format_status(:status, StringIO.new(output)) # FIXME This opens an HTML page that is supposed to support a whole lot of things that we don't really support yet!
    nil  
  end
end

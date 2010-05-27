require 'ruble'

command 'Remove' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do |context|    
    hg = ENV['TM_HG'] || "hg"
    Dir.chdir ENV['TM_PROJECT_DIRECTORY']
    %x{#{hg} remove #{ENV['TM_SELECTED_FILES']}}
  end
end

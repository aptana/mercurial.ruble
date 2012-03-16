require 'ruble'

command t(:commit) do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_html
  cmd.input = :none
  cmd.invoke do |context|
    require 'hg_commit'
    Dir.chdir ENV['TM_PROJECT_DIRECTORY']
    commit
    nil
  end
end

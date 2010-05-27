require 'ruble'

command 'Undo' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do |context|
    hg = ENV['TM_HG'] || "hg"
    work_path = ENV['TM_PROJECT_DIRECTORY'] || ENV['TM_DIRECTORY']
    Dir.chdir work_path
    output = %x{#{hg} rollback}
    context.project.refresh # will cause current project to be re-loaded
    output
  end
end

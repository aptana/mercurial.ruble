require 'ruble'

command 'Undo' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do |context|
    hg = ENV['TM_HG'] || "hg"
    output = %x{#{hg} rollback}
    context.project.refresh # will cause current project to be re-loaded
    output
  end
end

require 'ruble'

command t(:init) do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do |context|
    Dir.chdir ENV['TM_PROJECT_DIRECTORY']
    hg = ENV['TM_HG'] || "hg"
	  output = puts %x{#{hg} init}
    context.project.refresh # will cause current project to be re-loaded
    output # TODO On success basically nothing happens, we probably want some indication?!
  end
end

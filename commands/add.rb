require 'ruble'

command t(:add) do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do
    hg = ENV['TM_HG'] || "hg"
	  %x{#{hg} add #{ENV['TM_SELECTED_FILES']}}
  end
end

require 'ruble'

command 'AddRemove' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do
    hg = ENV['TM_HG'] || "hg"
    puts %x{#{hg} add}
    puts %x{#{hg} remmove --after}
    nil
  end
end

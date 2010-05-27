require 'ruble'

command 'Help' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_html
  cmd.input = :none
  cmd.invoke do
    require 'hg_show_help'
    show_help
  end
end

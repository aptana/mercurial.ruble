require 'ruble'

command 'Push to default repo' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do
    hg = ENV['TM_HG'] || "hg"
    working_dir = ENV['TM_PROJECT_DIRECTORY'] || ENV['TM_DIRECTORY']
    Ruble::Terminal.open("#{hg} push", working_dir)
    nil
  end
end

require 'ruble'

command 'Annotate' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_html
  cmd.input = :none
  cmd.invoke do
    hg = ENV['TM_HG'] || 'hg'
    output = `"#{hg}" annotate -nud "#{ENV['TM_FILEPATH']}" 2>&1`
    require 'format_annotate'
    require 'stringio'
    format_annotate(hg, StringIO.new(output))
    nil
  end
end

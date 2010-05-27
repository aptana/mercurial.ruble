require 'ruble'
require 'ruble/ui'
require 'ruble/editor'

command 'View Revision...' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :discard
  cmd.input = :none
  cmd.invoke do |context|
    hg = ENV['TM_HG'] || 'hg'
    work_path = ENV['TM_PROJECT_DIRECTORY'] || ENV['TM_DIRECTORY']
    Dir.chdir work_path
    revs = `#{hg} log -q "#{ENV['TM_FILEPATH']}"`.split
    context.exit_show_tooltip "No older revisions of file '#{ENV['TM_FILENAME']}' found" if revs.empty?
    chosen = Ruble::UI.request_item :items => revs, :prompt => "View older revision of '#{ENV['TM_FILENAME']}':"
    context.exit_discard if chosen.nil?
    
    require 'tmpdir'
    chosen = chosen.split(":").first
    filename = File.join(Dir.tmpdir, "rev#{chosen}-#{ENV['TM_FILENAME']}")
    `#{hg}  cat -r#{chosen} --output "#{filename}" "#{ENV['TM_FILEPATH']}"`
    Ruble::Editor.open filename
    nil
  end
end

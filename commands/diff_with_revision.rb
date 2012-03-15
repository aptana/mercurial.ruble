require 'ruble'

command t(:diff_revision) do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :discard
  cmd.input = :none  
  cmd.invoke do |context|
    hg = ENV['TM_HG'] || 'hg'
    work_path = ENV['TM_PROJECT_DIRECTORY'] || ENV['TM_DIRECTORY']
    Dir.chdir work_path
    
    revs = `#{hg} log -q "#{ENV['TM_FILEPATH']}"`.split
    context.exit_show_tooltip t(:no_revisions_found, :filename => ENV['TM_FILENAME']) if revs.empty?

    chosen = Ruble::UI.request_item :items => revs, :prompt => t(:choose_revision, :filename => ENV['TM_FILENAME'])
    context.exit_discard if chosen.nil?
    
    rev1 = chosen.split(":").first

    if ENV['TM_HG_EXT_DIFF']
      require 'hg_extdiff'
      Mercurial::diff_active_file(context, "-r#{rev1}")
    else
      require 'hg_diff'
      target_path = ENV['TM_SELECTED_FILE'] || ENV['TM_FILEPATH']
      output_path = target_path + ".diff"
    
      File.open(output_path, 'w') do |file|
        Mercurial::diff_active_file(context, "-r#{rev1}", file)
      end
      Ruble::Editor.open output_path
    end
    nil
  end
end

require 'ruble'

command t(:diff_revisions) do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :discard
  cmd.input = :none
  cmd.invoke do |context|
    hg = ENV['TM_HG'] || 'hg'
    work_path = ENV['TM_PROJECT_DIRECTORY'] || ENV['TM_DIRECTORY']
    Dir.chdir work_path
    
    revs = `#{hg} log -q "#{ENV['TM_FILEPATH']}"`.split
    context.exit_show_tooltip t(:two_or_more_revisions_not_found, :filename => ENV['TM_FILENAME']) if revs.size < 2
    chosen = []
    if revs.size == 2
      chosen = revs
    else
      # Add this text somewhere in dialog: "Please select two revisions (hold down the shift key to select multiple revisions)."
      chosen = Ruble::UI.request_item :items => revs, :prompt => t(:choose_two_revisions, :filename => ENV['TM_FILENAME']), :multiple => true
      context.exit_discard if chosen.nil?
      if chosen.length < 2
        # TODO Force them to re-pick
      end
    end
    
    rev1 = chosen[0].split(":").first
    rev2 = chosen[1].split(":").first

    if ENV['TM_HG_EXT_DIFF']
      require 'hg_extdiff'
      Mercurial::diff_active_file(context, "-r#{rev2} -r#{rev1}")
    else
      require 'hg_diff'
      target_path = ENV['TM_SELECTED_FILE'] || ENV['TM_FILEPATH']
      output_path = target_path + ".diff"
    
      File.open(output_path, 'w') do |file|
        Mercurial::diff_active_file(context, "-r#{rev2} -r#{rev1}", file)
      end
      Ruble::Editor.open output_path
    end
    nil
  end
end

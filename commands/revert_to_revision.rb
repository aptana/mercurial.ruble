require 'ruble'

command t(:revert_to_revision) do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do |context|
    hg = ENV['TM_HG'] || 'hg'
    work_path = ENV['TM_PROJECT_DIRECTORY'] || ENV['TM_DIRECTORY']
    Dir.chdir work_path
    revs = `#{hg} log -q "#{ENV['TM_FILEPATH']}"`.split
    context.exit_show_tooltip t(:no_revisions_found, :filename => ENV['TM_FILENAME']) if revs.empty?
    chosen = Ruble::UI.request_item :items => revs, :prompt => t(:revert_revision, :filename => ENV['TM_FILENAME'])
    context.exit_discard if chosen.nil?
    
    chosen = chosen.split(":").first
    # if ENV['TM_SELECTED_FILES']
    #   `#{hg} revert -r #{chosen} #{ENV['TM_SELECTED_FILES']}`
    # else
      `#{hg} revert -r #{chosen} #{ENV['TM_FILEPATH']}`
    # end
    context.project.refresh # TODO Only refresh the selected files!
    nil
  end
end

require 'ruble'

command t(:revert) do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do |context|
    hg = ENV['TM_HG'] || "hg"
    output = if ENV['TM_SELECTED_FILES']
      `#{hg} revert #{ENV['TM_SELECTED_FILES']}`
    else
      `#{hg} revert #{ENV['TM_FILEPATH']}`
    end
    context.project.refresh # TODO Only refresh files changed here!
    output
  end
end

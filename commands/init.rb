require 'ruble'

command 'Init' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do |context|
    #require_cmd "${TM_HG:=hg}" "If you have installed Mercurial, then you need to either update your <tt>PATH</tt> or set the <tt>TM_HG</tt> shell variable (e.g. in Preferences / Advanced)"

    Dir.chdir ENV['TM_PROJECT_DIRECTORY']
    hg = ENV['TM_HG'] || "hg"
	  output = puts %x{#{hg} init}
    context.project.refresh # will cause current file to be re-loaded
    output # TODO On success basically nothing happens, we probably want some indication?!
  end
end

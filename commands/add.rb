require 'ruble'

command 'Add' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_tooltip
  cmd.input = :none
  cmd.invoke do
    #require_cmd "${TM_HG:=hg}" "If you have installed hg, then you need to either update your <tt>PATH</tt> or set the <tt>TM_HG</tt> shell variable (e.g. in Preferences / Advanced)"
	  hg = ENV['TM_HG'] || "hg"
	  %x{#{hg} add #{ENV['TM_SELECTED_FILES']}}
  end
end

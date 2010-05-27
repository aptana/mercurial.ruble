require 'ruble'

command 'Diff with Working Copy' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :create_new_document
  cmd.input = :none
  cmd.invoke =<<-EOF
require_cmd "${TM_HG:=hg}" "If you have installed hg, then you need to either update your <tt>PATH</tt> or set the <tt>TM_HG</tt> shell variable (e.g. in Preferences / Advanced)"

if [[ -d "$TM_PROJECT_DIRECTORY" ]]
   then export WorkPath="$TM_PROJECT_DIRECTORY"; cd "$TM_PROJECT_DIRECTORY"
   else export WorkPath="$TM_DIRECTORY"; cd "$TM_PROJECT_DIRECTORY"
fi

"${TM_RUBY:=ruby}" -I "$TM_BUNDLE_SUPPORT/" <<END
	if ENV['TM_HG_EXT_DIFF']
		require 'hg_extdiff'
	else
		require 'hg_diff'
	end
	Mercurial::diff_active_file("", "Diff With Working Copy")
END
EOF
end

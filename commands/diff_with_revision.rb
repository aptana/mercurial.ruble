require 'ruble'

command 'Diff with Revision...' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :create_new_document
  cmd.input = :none
  cmd.invoke =<<-EOF
require_cmd "${TM_HG:=hg}" "If you have installed hg, then you need to either update your <tt>PATH</tt> or set the <tt>TM_HG</tt> shell variable (e.g. in Preferences / Advanced)"

if [[ -d "$TM_PROJECT_DIRECTORY" ]]
   then export WorkPath="$TM_PROJECT_DIRECTORY"; cd "$TM_PROJECT_DIRECTORY"
   else export WorkPath="$TM_DIRECTORY"
fi

revs=$("$TM_HG" log -q "$TM_FILEPATH" \
	2> >(CocoaDialog progressbar --indeterminate \
		--title "Diff Revisions…" \
		--text "Retrieving List of Revisions…" \
	))

revs=`osascript<<END
	set AppleScript's text item delimiters to {"\n","\r"}
	tell app "SystemUIServer"
		activate
		set ourList to (every text item of "$revs")
		if the count of items in ourList is 0 then
			display dialog "No older revisions of file '$(basename "$TM_FILEPATH")' found" buttons ("OK")
			set the result to false
		else
			choose from list ourList with prompt "Diff '$(basename "$TM_FILEPATH")' with older revision:"
		end if
	end tell
END`

# exit if user canceled
if [[ $revs = "false" ]]; then
	osascript -e 'tell app "TextMate" to activate' &>/dev/null &	exit_discard
fi


revs=`echo "$revs" | tr '\r' '\n' | cut -d ":" -f 1`
revs=( $revs )

"${TM_RUBY:=ruby}" -I "$TM_BUNDLE_SUPPORT/" <<END
	if ENV['TM_HG_EXT_DIFF']
		require 'hg_extdiff'
	else
		require 'hg_diff'
	end
	Mercurial::diff_active_file("-r${revs[0]#r}", "Diff With Revision…")
END

EOF
end

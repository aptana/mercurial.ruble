require 'ruble'

command 'Diff Revisions...' do |cmd|
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

revs=`osascript <<END
	set theResult to false
	set AppleScript's text item delimiters to {"\n","\r"}
	tell app "SystemUIServer"
		activate
		set ourList to (every text item of "$revs")
		if the count of items in ourList is 0 then
			display dialog "No revisions of file '$TM_FILENAME' found" buttons ("Continue") default button 1
		else
			tell app "SystemUIServer" to choose from list (every text item of "$revs") with prompt "Please choose two revisions of '$TM_FILENAME':" with multiple selections allowed

			set theitems to the result
			if theitems is not false then
				if the count of items in the theitems is less than 2 then
					display dialog "Please select two revisions (hold down the shift key to select multiple revisions)." buttons ("Continue") default button 1
				else
					set theResult to (item 1 of theitems) & return & (item 2 of theitems)
				end if
			end if 
		end if
		set the result to theResult
	end tell
END`

# exit if user canceled
if [[ $revs = "false" ]]; then
	osascript -e 'tell app "TextMate" to activate' &>/dev/null &	exit_discard
fi


revs=`echo "$revs" | tr '\r' '\n' | cut -d ":" -f 1`
revs=( $revs )



rev1=${revs[0]#r}
rev2=${revs[1]#r}

"${TM_RUBY:=ruby}" -I "$TM_BUNDLE_SUPPORT/" <<END
	if ENV['TM_HG_EXT_DIFF']
		require 'hg_extdiff'
	else
		require 'hg_diff'
	end
	Mercurial::diff_active_file("-r$rev2 -r$rev1", "Diff Revisions…")
END

EOF
end

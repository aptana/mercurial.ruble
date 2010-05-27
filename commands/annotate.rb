require 'ruble'

command 'Annotate' do |cmd|
  cmd.key_binding = 'M4+M2+M'
  cmd.output = :show_as_html
  cmd.input = :none
  cmd.invoke =<<-EOF
require_cmd "${TM_HG:=hg}" "If you have installed hg, then you need to either update your <tt>PATH</tt> or set the <tt>TM_HG</tt> shell variable (e.g. in Preferences / Advanced)"

"$TM_HG" annotate -nud "$TM_FILEPATH" 2>&1 \
|"${TM_RUBY:-ruby}" -- "${TM_BUNDLE_SUPPORT}/format_annotate.rb"
EOF
end

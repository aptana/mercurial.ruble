require 'English' # you are angry, english!

def current_dir
  Dir.pwd + "/"
end

def matches_to_paths(matches)
  paths = matches.collect {|m| m[2] }
  paths.collect{|path| path.sub(/^#{current_dir}/, "") }
end

def matches_to_status(matches)
  matches.collect {|m| m[0]}
end

def commit
  hg = ENV['TM_HG'] || "hg"
  commit_tool   = ENV['CommitWindow'] || "/Applications/TextMate.app/Contents/SharedSupport/Support/bin/CommitWindow.app/Contents/MacOS/CommitWindow"
  ignore_file_pattern = /(\/.*)*(\/\..*|\.(tmproj|o|pyc)|Icon)/
  
  require "lib/Builder"
  require "hg_helper"
  require 'shelltokenize'
  include HGHelper
  
  mup = Builder::XmlMarkup.new(:target => $stdout)
  
  begin
    unless ENV['TM_HG_FROM_STATUS']
      make_head( "Hg Commit", current_dir,
      [ ENV['TM_BUNDLE_SUPPORT'] + "/Stylesheets/hg_style.css", ENV['TM_BUNDLE_SUPPORT'] + "/Stylesheets/hg_commit_style.css"] )
    else
      mup.h4 "Console:"
    end
    $stdout.flush
  
  
    # Ignore files without changes
    status_command = %Q{"#{hg}" status #{ENV['TM_SELECTED_FILES']}}
    status_output = %x{#{status_command}}
    paths = status_output.scan(/^(.)(\s+)(.*)\n/)
  
    # Ignore files with '?', but report them to the user
    unknown_paths = paths.select { |m| m[0] == '?' }
    unknown_to_report_paths = paths.select{ |m| m[0] == '?' and not ignore_file_pattern =~ m[2]}
    if unknown_to_report_paths and unknown_to_report_paths.size > 0 then
  
      mup.div( "class" => "info" ) {
        mup.text! "These files are not added to the repository, and so will not be committed:"
        mup.ul{ matches_to_paths(unknown_to_report_paths).each{ |path| mup.li(path) } }
      }
    end
  
    # Fail if we have conflicts -- hg commit will fail, so let's
    # error out before the user gets too involved in the commit
    conflict_paths = paths.select { |m| m[0] == 'C' }
  
    if conflict_paths and conflict_paths.size > 0 then
      mup.div( "class" => "error" ) {
        mup.text! "Cannot continue; there are merge conflicts in files:"
        mup.ul{ matches_to_paths(conflict_paths).each{ |path| mup.li(path) } }
        mup.text! "Canceled."
      }
      exit(-1)
    end
  
    # Remove the unknown paths from the commit
    commit_matches = paths - unknown_paths
  
    if commit_matches.nil? or commit_matches.size == 0
      mup.div( "class" => "info" ) {
        mup.text! "File(s) not modified; nothing to commit."
        mup.ul{ matches_to_paths(unknown_paths).each{ |path| mup.li(path) } }
      }
      exit 0
    end
  
    $stdout.flush
  
    commit_paths_array = matches_to_paths(commit_matches)
    commit_status = matches_to_status(commit_matches).join(":")
    commit_path_text = commit_paths_array.collect{|path| path.quote_filename_for_shell }.join(" ")
    commit_args = %x{"#{commit_tool}" --status #{commit_status} #{commit_path_text}}
  
    status = $CHILD_STATUS
    if status != 0
      mup.div( "class" => "error" ) {
        mup.text! "Canceled (#{status >> 8})."
      }
      exit(-1)
    end
  
    mup.div("class" => "command"){ mup.strong(%Q{#{hg} commit}); mup.text!(commit_args) }
  
    mup.pre {
      $stdout.flush
  
      IO.popen("#{hg} commit #{commit_args}", "r+") do |pipe|
        pipe.each {|line| mup.text! line }
      end
    }
  rescue => e
    handle_default_exceptions( e )
  ensure
    make_foot() unless ENV['TM_HG_FROM_STATUS']
  end
end
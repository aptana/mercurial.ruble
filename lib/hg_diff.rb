#!/usr/bin/env ruby -w
# encoding: utf-8

module Mercurial
  def Mercurial.diff_active_file( context, revision, io )
    hg             = ENV['TM_HG'] || 'hg'
    target_path    = ENV['TM_SELECTED_FILE'] || ENV['TM_FILEPATH']
    work_path      = ENV['WorkPath']

    revs = revision.gsub( '-r', '' ).split( ' ' )       
    the_diff = %x{cd "#{work_path}";"#{hg}" diff #{revision} "#{target_path}"}
       
    context.exit_show_tooltip t(:no_differences_found) if the_diff.empty?
    
    # idea here is to stream the data rather than submit it in one big block
    the_diff.each_line do |line|
      if line =~ /^diff -r (\w+)( -r (\w+))? .*/
        io.puts t(:index_0, :target_path => target_path)
        io.puts "===================================================================\n"
             
        if revs[1]
          io.puts t(:diff_revs_0_and_1, :rev_0 => revs[0], :name_0 => $1, :rev_1 => revs[1], :name_1 => $2)
        elsif revs[0] == 'tip'
          io.puts t(:diff_tip_0, :name => $1)
        elsif revs.empty?
          io.puts t(:diff_working_copy_0, :name => $1)
        else
          io.puts t(:diff_revision_0_1, :rev => revs[0], :name => $1)
        end
      elsif line =~ /(^@@\s*.+?\s*@@)(.*)?/
        io.puts $1
      else
        io.puts line
      end
    end
  end
end

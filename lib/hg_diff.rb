#!/usr/bin/env ruby -w
# encoding: utf-8

module Mercurial
  def Mercurial.diff_active_file( context, revision, io )
    hg             = ENV['TM_HG'] || 'hg'
    target_path    = ENV['TM_SELECTED_FILE'] || ENV['TM_FILEPATH']
    work_path      = ENV['WorkPath']

    revs = revision.gsub( '-r', '' ).split( ' ' )       
    the_diff = %x{cd "#{work_path}";"#{hg}" diff #{revision} "#{target_path}"}
       
    context.exit_show_tooltip "No differences found." if the_diff.empty?     
    
    # idea here is to stream the data rather than submit it in one big block
    the_diff.each_line do |line|
      if line =~ /^diff -r (\w+)( -r (\w+))? .*/
        io.puts "Index: " + target_path
        io.puts "===================================================================\n"
             
        if revs[1]
          io.puts "diff of revs " + revs[0] + " (#{$1})" + " and " + revs[1] + " (#{$2})" 
        elsif revs[0] == 'tip'
          io.puts "diff with tip (#{$1})"
        elsif revs.empty?
          io.puts "diff with working copy (#{$1})"
        else
          io.puts "diff with revision " + revs[0] + "(#{$1})"
        end
      elsif line =~ /(^@@\s*.+?\s*@@)(.*)?/
        io.puts $1
      else
        io.puts line
      end
    end
  end
end

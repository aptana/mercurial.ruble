#!/usr/bin/env ruby -w

module Mercurial
  def Mercurial.diff_active_file( context, revision )
    hg             = ENV['TM_HG'] || 'hg'
    target_path    = ENV['TM_SELECTED_FILE'] || ENV['TM_FILEPATH']
    work_path      = ENV['WorkPath']
    path           = target_path.sub(/^#{work_path}\//, '')
    difftool        = ENV['TM_HG_EXT_DIFF']
      
    the_diff = %x{cd "#{work_path}";"#{hg}" diff #{revision} "#{target_path}"}      
    
    context.exit_show_tooltip t(:no_differences_found) if the_diff.empty?
    
    context.exit_show_tooltip %x{cd "#{work_path}";"#{hg}" #{difftool} #{revision} "#{target_path}"}
  end
end

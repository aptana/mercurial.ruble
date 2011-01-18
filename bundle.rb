require 'ruble'

bundle 'Mercurial' do |bundle|
  bundle.author = 'Frédéric Ballériaux'
  bundle.contact_email_rot_13 = 'serqo7@fgnesynz.pbz'
  bundle.description =  <<END
<a href="http://www.selenic.com/mercurial/">Mercurial</a> is a source Control Management system designed for efficient handling of very large distributed projects.
END

  bundle.menu 'Mercurial' do |main_menu|
    main_menu.command 'Add'
    main_menu.command 'AddRemove'
    main_menu.command 'Remove'
    main_menu.command 'Update'
    main_menu.separator
    main_menu.command 'Commit'
    main_menu.separator
    main_menu.command 'View Revision...'
    main_menu.command 'Annotate'
    main_menu.command 'Log'
    main_menu.command 'Log -v'
    main_menu.command 'Status'
    main_menu.separator
    main_menu.menu 'Diff' do |submenu|
      submenu.command 'Diff with Working Copy'
      submenu.command 'Diff with Revision...'
      submenu.command 'Diff Revisions...'
      submenu.command 'Diff with Newest (Tip)'
    end
    main_menu.separator
    main_menu.command 'Revert'
    main_menu.command 'Revert to Revision...'
    main_menu.command 'Undo'
    main_menu.separator
    main_menu.command 'Init'
    main_menu.command 'incoming'
    main_menu.command 'outgoing'
    main_menu.command 'Pull from default repo'
    main_menu.command 'Push to default repo'
    main_menu.separator
    main_menu.command 'Help'
  end
end

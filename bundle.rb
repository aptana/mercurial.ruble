require 'ruble'

bundle do |bundle|
  bundle.display_name = t(:bundle_name)
  bundle.author = 'Frédéric Ballériaux'
  bundle.contact_email_rot_13 = 'serqo7@fgnesynz.pbz'
  bundle.description = t(:bundle_description)

  bundle.menu t(:bundle_name) do |main_menu|
    main_menu.command t(:add)
    main_menu.command t(:add_remove)
    main_menu.command t(:remove)
    main_menu.command t(:update)
    main_menu.separator
    main_menu.command t(:commit)
    main_menu.separator
    main_menu.command t(:view_revision)
    main_menu.command t(:annotate)
    main_menu.command t(:log)
    main_menu.command t(:log_v)
    main_menu.command t(:status)
    main_menu.separator
    main_menu.menu t(:diff) do |submenu|
      submenu.command t(:diff_working_copy)
      submenu.command t(:diff_revision)
      submenu.command t(:diff_revisions)
      submenu.command t(:diff_newest)
    end
    main_menu.separator
    main_menu.command t(:revert)
    main_menu.command t(:revert_to_revision)
    main_menu.command t(:undo)
    main_menu.separator
    main_menu.command t(:init)
    main_menu.command t(:incoming)
    main_menu.command t(:outgoing)
    main_menu.command t(:pull)
    main_menu.command t(:push)
    main_menu.separator
    main_menu.command t(:help)
  end
end

require 'java'

# class MyKeyListener
#   include org.eclipse.swt.events.KeyListener
#   
#   def initialize(dialog)
#     Ruble::Logger.log_error "creating key listener"
#     @dialog = dialog
#   end
#   # FIXME The key listener seems to get created, but these callback methods never get invoked!
#   def key_pressed(event)
#     @dialog.validate
#   end
#   
#   def key_released(event)
#     @dialog.validate
#   end
# end

class CommitDialog < org.eclipse.jface.dialogs.StatusDialog
  
  def initialize(parent, statuses, paths)
    super(parent)
    @map = Hash[*paths.zip(statuses).flatten]
    @files = ''
    @commit_message = ''
  end
  
  def self.create(statuses, paths)
    CommitDialog.new(org.eclipse.ui.PlatformUI.workbench.display.active_shell, statuses, paths)
  end
  
  def createButton(parent, id, label, defaultButton)
    label = "Commit" if id == org.eclipse.jface.dialogs.IDialogConstants::OK_ID
    return super(parent, id, label, defaultButton)
  end
  
  def createDialogArea(parent)
    container = super(parent)
    parent.shell.text = "Commit"
    container.layout = org.eclipse.swt.layout.GridLayout.new(1, true)
    
    gd = org.eclipse.swt.layout.GridData.new(org.eclipse.swt.SWT::FILL, org.eclipse.swt.SWT::FILL, true, true)
    gd.heightHint = 110
    gd.widthHint = 440
    
    status_label = org.eclipse.swt.widgets.Label.new(container, org.eclipse.swt.SWT::NONE)
    status_label.text = "Summary of changes:"
    
    # text area for commit message
    @text_area = org.eclipse.swt.widgets.Text.new(container, org.eclipse.swt.SWT::BORDER | org.eclipse.swt.SWT::MULTI | org.eclipse.swt.SWT::WRAP)
    @text_area.layout_data = gd
    # FIXME This isn't working!!!
    # @text_area.addKeyListener(MyKeyListener.new(self))
    
    label = org.eclipse.swt.widgets.Label.new(container, org.eclipse.swt.SWT::NONE)
    label.text = "Choose files to commit:"

    # Create a table with 3 columns: "<checkbox>" "<status image>" "File <filepath>"
    @table = org.eclipse.swt.widgets.Table.new(container, org.eclipse.swt.SWT::CHECK | org.eclipse.swt.SWT::BORDER | org.eclipse.swt.SWT::V_SCROLL | org.eclipse.swt.SWT::FULL_SELECTION)
    @table.header_visible = true
    @table.layout_data = gd
    
    # Status
    org.eclipse.swt.widgets.TableColumn.new(@table, org.eclipse.swt.SWT::NONE)
    # File column
    column = org.eclipse.swt.widgets.TableColumn.new(@table, org.eclipse.swt.SWT::NONE)
    column.text = "File"

    # Add all the files to the table
    @map.each do |path, status|
      item = org.eclipse.swt.widgets.TableItem.new(@table, org.eclipse.swt.SWT::NONE)
      item.setText(0, status) # Use an image?
      item.setText(1, path)
      item.checked = true
      @files << " '#{path}'"
    end
    
    @table.columns.each {|col| col.pack }
    @table.pack
    
    return container
  end
  
  def okPressed
    @commit_message = @text_area.text
    @files = ''
    @table.items.each {|item| @files << " '#{item.getText(1)}'" if item.checked }
    super
  end
  
  def isResizable
    true
  end
  
  def args
    "-m '#{@commit_message}'#{@files}"
  end
  
  # Never gets called right now because the listener callback stuff is bombing
  def validate
    Ruble::Logger.log_error "validating"
    if @text_area.text.length < 3
      updateStatus(org.eclipse.core.runtime.Status.new(org.eclipse.core.runtime.IStatus::ERROR, "mercurial.ruble", "Please enter a commit message"))
      return
    end
        
    @commit_message = @text_area.text
    updateStatus(org.eclipse.core.runtime.Status::OK_STATUS)
  end
end

class AddTemporaryToReports < Reports::Migration
  def change
    add_column :reports_reports, :temporary, :boolean, default: false
  end
end

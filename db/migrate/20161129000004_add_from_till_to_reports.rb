class AddFromTillToReports < Reports::Migration
  def change
    begin
      Reports::Base.delete_all
    rescue
    end
    add_column :reports_reports, :from, :datetime, null: false
    add_column :reports_reports, :till, :datetime, null: false
  end
end

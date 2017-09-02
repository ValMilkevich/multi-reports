class AmendReportsTableToNotNullAndUnique < Reports::Migration
  def change
    change_column :reports_reports, :type, 'string', null: false
    change_column :reports_reports, :data, 'json', default: {}, null: false
    change_column :reports_reports, :key, 'string', null: false
    change_column :reports_reports, :timestamp, 'datetime', null: false

    begin
      remove_index :reports_reports, [:key]
    rescue
    end
    add_index :reports_reports, [:type, :key], unique: true
  end
end

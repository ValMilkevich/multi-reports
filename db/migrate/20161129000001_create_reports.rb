class CreateReports < Reports::Migration
  def change
    create_table :reports_reports do |t|
      t.string :type
      t.column :data, 'json', default: {}
      t.string :key
      t.datetime :timestamp
      t.timestamps null: false
    end

    add_index :reports_reports, [:key]
    add_index :reports_reports, [:type, :timestamp]
  end
end

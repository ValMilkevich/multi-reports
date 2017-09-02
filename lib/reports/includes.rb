require "reports/includes/database_tasks"
require "reports/includes/csv"
require "reports/includes/report_data"

module Reports
  module Includes
  end
end

ActiveRecord::Tasks::DatabaseTasks.send(:include, Reports::Includes::DatabaseTasks)
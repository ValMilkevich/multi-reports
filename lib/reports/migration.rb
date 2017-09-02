module Reports
  class Migration < ActiveRecord::Migration

    #  Setting the migration's connection from the Reports::Base configuration
    #
    def connection
      # ActiveRecord::Base.establish_connection(
      #   Reports::Config.database_configuration
      # ).connection
      ::Reports::Base.connection
    end
  end
end
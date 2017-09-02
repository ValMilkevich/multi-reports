#  Includes for Database tasks, like drop / create database
#
module Reports
  module Includes
    module DatabaseTasks
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def create_all
          super
          create ::Reports::Config.database_configuration if ::Reports::Config.database_configuration.present?
        end

        def drop_all
          super
          drop ::Reports::Config.database_configuration if ::Reports::Config.database_configuration.present?
        end

        def drop_current
          super
          drop ::Reports::Config.database_configuration if ::Reports::Config.database_configuration.present?
        end

        def create_current
          super
          create ::Reports::Config.database_configuration if ::Reports::Config.database_configuration.present?
        end
      end
    end
  end
end
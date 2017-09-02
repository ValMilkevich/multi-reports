#  Includes for .to_csv task for reports as a collection or single record
#
module Reports
  module Includes
    module ReportData
      extend ActiveSupport::Concern

      def self.included(base)
        #  Holds an array of the defined data keys to be saved to element.data[key]
        #
        base.class_attribute :report_data_keys
      end

      module ClassMethods

        #  Class method defining an instance method named after the :key, and executing the block provided
        #
        def report_data_attribute key, &block
          self.report_data_keys ||= []
          self.report_data_keys.push(key)

          #  Creating a method for calculation of the value and saving it to instance's data
          #
          define_method key do |*args|
            method_name = key
            instance_variable_set("@#{method_name}", instance_variable_get("@#{method_name}") || instance_exec(*args, &block) )
          end

          #  Creating a method for calculation of the value and saving it to instance's data with force cache update
          #
          define_method "#{key}!" do |*args|
            instance_variable_set("@#{key}", nil)
            self.send(key, *args)
          end

          #  Creating a method for calculation of the change in comparison to the previous period value
          #
          define_method "#{key}_change" do
            method_name = "#{key}_change"
            instance_variable_set("@#{method_name}", variation(self.send(key), previous.send(key)) )
          end

          #  Creating a method for calculation of the difference in comparions to the previous period value
          #
          define_method "#{key}_diff" do
            method_name = "#{key}_diff"
            instance_variable_set("@#{method_name}", (self.send(key) - previous.send(key)) )
          end

          #  Creating a method for calculation of the difference in comparions to the previous period value
          #
          define_method "#{key}_pct" do |from|
            method_name = "#{key}_pct"
            instance_variable_set("@#{method_name}", fperc( self.send(key) / from.to_f ))
          end
        end

      end
    end
  end
end
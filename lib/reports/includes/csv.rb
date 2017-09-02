#  Includes for .to_csv task for reports as a collection or single record
#
module Reports
  module Includes
    module Csv
      extend ActiveSupport::Concern

      def self.included(base)
        base.class_attribute :report_description
        base.class_attribute :report_headers
        base.class_attribute :report_title

        base.const_get('ActiveRecord_Relation').include(RelationMethods)
        base.extend(ExtendMethods)
      end

      #  Showing record as a .csv compatible string w/o header line
      #
      def to_csv(opts = {})
        return "\n" if self.data.blank?

        headers = opts[:headers] || self.class.default_headers(self)

        [].tap do |result|
          result << i18n_headers(headers.map(&:first)).join( opts[:separator] || self.class.to_csv_value_separator ) if !opts[:skip_header]
          result << headers.map{|h| h.second.call(self) }.join( opts[:separator] || self.class.to_csv_value_separator )
        end.join(self.class.to_csv_line_separator)
      end

      #  Module containing methods to be extended into the target
      #
      module ExtendMethods
        #  Allowing all child classes to extend ActiveRecord_Relation
        #
        def inherited(child_class)
          (super || 0) + (child_class.const_get('ActiveRecord_Relation').include(RelationMethods) ? 1 : 0 )
        end
      end

      module ClassMethods
        def i18n_headers(headers)
          headers.map{|h| I18n.t( (self.to_s.downcase.split('::') << h.gsub(/[\.\s]/, '_').downcase).join('.'), default: h.gsub('_percentage', '%')) }
        end

        def to_csv_value_separator
          ","
        end

        def to_csv_line_separator
          "\n"
        end

        #  Extract headers from .report_headers method and passed in records
        #
        def default_headers(records)
          headers = []
          self.report_headers.each do |key, type|
            if type.is_a?(Array)
              keys = if type.blank?
                [records].flatten.map{|record| record.send(key).keys }.flatten.uniq
              else
                type
              end

              keys.each do |record_header_key|
                headers << [ record_header_key.to_s, Proc.new{|object| object.send(key).try(:[], record_header_key) } ]
              end
            end

            if type.is_a?(String) || type.is_a?(Symbol)
              headers << [ key.to_s.humanize, Proc.new{|object| object.send(header) } ]
            end

            if type.is_a?(Proc)
              headers << [ key.to_s.humanize, type ]
            end
          end
          headers
        end
      end

      #  Holds methods to be added to relation class
      #
      module RelationMethods
        extend ActiveSupport::Concern

        #  Showing record as a .csv compatible string w/o header line
        #
        def to_csv(opts = {})
          headers = default_headers(self)

          if opts[:headers]
            headers = headers.select{|h| opts[:headers].include?(h.first) }
          end

          [].tap do |result|
            result << i18n_headers(headers.map(&:first)).join( opts[:separator] || self.to_csv_value_separator ) if !opts[:skip_header]
            self.each do |record|
              result << record.to_csv(headers: headers, skip_header: true )
            end
            result
          end.join(self.to_csv_line_separator)
        end
      end
    end
  end
end
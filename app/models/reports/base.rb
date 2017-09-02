# Engine module
#
module Reports
  # Base Reports class
  #
  class Base < ActiveRecord::Base
    include Reports::Includes::Csv
    include Reports::Includes::ReportData
    include Reports::Calculus

    class_attribute :custom_octopus_connection, :interval
    self.custom_octopus_connection = true
    self.table_name = 'reports_reports'

    #  Unique key of the report, so that it can't be overriten
    #
    attr_readonly :key

    #  Scope and Resolution of the current report
    #
    attr_accessor :scope

    validates :key, uniqueness: { scope: [:type, :temporary] }, presence: true
    validates :timestamp, :from, :till, presence: true

    before_validation :generate_key, :generate_from_till

    before_create :calculate
    before_save :calculate, if: :temporary
    before_create :destroy_temporary, unless: :temporary


    self.report_headers = { 
      from: Proc.new{|record| record.from.in_time_zone(Time.zone) },
      till: Proc.new{|record| (record.temporary? && record.updated_at < record.till) ? record.updated_at.in_time_zone(Time.zone) : record.till.in_time_zone(Time.zone) },
      data: []
    }

    #  Scope with default
    #
    def scope
      @scope ||= Reports::Scope.new()
    end

    def timestamp
      self[:timestamp] ||= scope.timestamp
    end

    def calculate
      raise "Is not implemented"
    end

    # Override .temporary field to be true if the current period
    #
    def temporary
      self.temporary = self.try(:start_end).try(:[], :end).to_i > Time.zone.now.to_i
    end

    #  Resulting hash with indifferent access
    #
    def data
      HashWithIndifferentAccess.new(self[:data])
    end

    #  Returns previous interval or inits new record
    #
    def previous(interval = self.class.interval)
      @previous ||= self.class.key(timestamp - interval).first_or_initialize(timestamp: timestamp - interval )
    end

    #  Returns previous interval or creates it
    #
    def previous!(interval = self.class.interval)
      if previous(interval).new_record?
        previous(interval).save
      end
      previous(interval)
    end


    #  Returns prefix in locale file
    #
    def i18n_prefix
      self.class.i18n_prefix
    end

    #  Returns prefix in locale file
    #
    def self.i18n_prefix
      self.to_s.tableize.gsub('/', '.')
    end

    #  Generating a key by timestamp of the current instance
    #
    def generate_key
      self.key = self.class.generate_key( self.timestamp )
    end

    #  Generates from / till timeframe for the reports basing on the timestamp
    #
    def generate_from_till
      self.from = self.try(:start_end).try :[], :start
      self.till = self.try(:start_end).try :[], :end
    end

    def self.key(timestamp)
      where(key: self.generate_key(timestamp))
    end

    private
    #  Destroys any outstanding temporary reports for this period
    #
    def destroy_temporary
      self.class.key(self.timestamp).where(temporary: true).destroy_all
    end

    #  Generating a key by timestamp
    #
    def self.generate_key(timestamp)
      timestamp.to_i
    end

    establish_connection(Reports::Config.database_configuration)
  end
end

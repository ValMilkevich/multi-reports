# Engine module
#
module Reports

  #  Reports Scope class to store data in between reports
  #
  class Scope < OpenStruct

    def timestamp
      self[:timestamp] ||= Time.zone.now
    end

    def app_available_date
      Time.parse("2014-01-06 00:00:00").in_time_zone(Time.zone)
    end

    def num_days_available
      ((timestamp - self.app_available_date) / (60 * 60 * 24)).ceil
    end

    def num_days_sales_available
      res = ((timestamp - app_available_date) / (60 * 60 * 24)).ceil
      res += 1 if res == 1
      res
    end
  end
end

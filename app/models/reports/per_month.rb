# Engine module
#
module Reports

  #  Holds reference to the Monthly based report
  #
  class PerMonth < Reports::Base

    #  In case we want to calculate the current period data, then we need to provide timestamp in the future ( as if we are calculating previous period from the future )
    #
    validate :timestamp_for_month, unless: :temporary

    self.interval = 1.month

    def generate_key
      super
    end

    def self.generate_key(timestamp)
      super(timestamp.at_beginning_of_month)
    end

    #  Parameters to be used in data quering
    #
    def start_end(interval = self.class.interval)
      {
        start: (timestamp.at_end_of_month + 1.second - self.class.interval).at_beginning_of_month.utc,
        end: timestamp.at_end_of_month.utc
      }
    end

    private

    #  Ensure that this report is run on the full day
    #
    def timestamp_for_month
      if timestamp > Time.zone.now.at_beginning_of_month
        self.errors.add(:timestamp, 'should be not earlier then the beginning of this month.')
      end
    end
  end
end

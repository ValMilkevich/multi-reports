# Engine module
#
module Reports

  #  Holds reference to the daily based report
  #
  class PerDay < Reports::Base

    #  In case we want to calculate the current period data, then we need to provide timestamp in the future ( as if we are calculating previous period from the future )
    #
    validate :timestamp_for_day, unless: :temporary

    self.interval = 1.day

    def generate_key
      super
    end

    def self.generate_key(timestamp)
      super(timestamp.at_beginning_of_day)
    end

    #  Parameters to be used in data quering
    #
    def start_end(interval = self.class.interval)
      {
        start: (timestamp.at_end_of_day + 1.second - interval).at_beginning_of_day.utc,
        end: timestamp.at_end_of_day.utc
      }
    end

    private

    #  Ensure that this report is run on the full day, please consider Today report
    #
    def timestamp_for_day
      if timestamp > Time.zone.now.at_beginning_of_day
        self.errors.add(:timestamp, 'should be not earlier then the beginning of this day.')
      end
    end
  end
end

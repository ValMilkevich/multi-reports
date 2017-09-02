# Engine module
#
module Reports

  #  Holds reference to the Week based report
  #
  class PerWeek < Reports::Base

    #  In case we want to calculate the current period data, then we need to provide timestamp in the future ( as if we are calculating previous period from the future )
    #
    validate :timestamp_for_week, unless: :temporary

    self.interval = 1.week

    def generate_key
      super
    end

    def self.generate_key(timestamp)
      super(timestamp.at_beginning_of_week)
    end

    #  Parameters to be used in data quering
    #
    def start_end(interval = self.class.interval)
      {
        start: (timestamp.at_end_of_week + 1.second - self.class.interval).at_beginning_of_week.utc,
        end: timestamp.at_end_of_week.utc
      }
    end

    private

    #  Ensure that this report is run on the full week
    #
    def timestamp_for_week
      if timestamp > Time.zone.now.at_beginning_of_week
        self.errors.add(:timestamp, 'should be not earlier then the beginning of this week.')
      end
    end
  end
end

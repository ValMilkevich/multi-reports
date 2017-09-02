# Engine module
#
module Reports

  #  Holds reference to the Yearly based report
  #
  class PerYear < Reports::Base

    #  In case we want to calculate the current period data, then we need to provide timestamp in the future ( as if we are calculating previous period from the future )
    #
    validate :timestamp_for_year, unless: :temporary

    self.interval = 1.year

    def generate_key
      super
    end

    def self.generate_key(timestamp)
      super(timestamp.at_beginning_of_year)
    end

    #  Parameters to be used in data quering
    #
    def start_end(interval = self.class.interval)
      {
        start: (timestamp.at_end_of_year + 1.second - self.class.interval).at_beginning_of_year.utc,
        end: timestamp.at_end_of_year.utc
      }
    end

    private

    #  Ensure that this report is run on the full day, please consider Today report
    #
    def timestamp_for_year
      if timestamp > Time.zone.now.at_beginning_of_year
        self.errors.add(:timestamp, 'should be not earlier then the beginning of this year.')
      end
    end
  end
end

# Engine module
#
module Reports

  #  Holds reference to the daily based report
  #
  module Calculus
    extend ActiveSupport::Concern

    #  Formats percentage based number
    #
    def fperc num
      if num.to_f.finite?
        ( num.to_f * 100 ).round(1).to_d
      else
        0.to_d
      end
    end

    #  Returns a variation between values
    #
    def variation(current, previous)
      fperc( (current.to_f - previous.to_f) / previous.to_f.to_d )
    end
  end
end

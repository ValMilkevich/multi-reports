module Reports
  class ReportsController < ApplicationController
    def index
      respond_to do |format|
        format.csv do
          render text: Report::Base.where( ["timestamp > :from and timestamp < :till", from: params.require(:from), till: params.permit(:till) || Time.now ] ).to_csv
        end
      end
    end
  end
end

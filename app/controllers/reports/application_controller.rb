module Reports
  class ApplicationController < ActionController::Base
    def reports
      render text: "Hola!"
    end
  end
end

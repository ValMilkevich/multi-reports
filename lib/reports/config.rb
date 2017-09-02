module Reports
  #  Class holiding reference to all configuration
  #
  class Config

    def self.database_configuration
      HashWithIndifferentAccess.new(YAML.load(ERB.new(File.read(Rails.root.join("config/reports.yml"))).result)[Rails.env])
    end

  end
end
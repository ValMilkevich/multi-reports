module Reports
  class Engine < ::Rails::Engine
    isolate_namespace Reports

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end

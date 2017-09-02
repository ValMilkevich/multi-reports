require 'rails_helper'

describe Reports::Base do
  let(:report){ Reports::Base.new }
  let(:scope){ Reports::Scope.new }

  describe "#scope" do
    it 'initializes with Reports::Scope' do
      expect( Reports::Base.new.scope ).to eq(Reports::Scope.new)
    end

    it 'sets timestamp to be equal to scope' do 
      expect( report.timestamp ).to eq( report.scope.timestamp )
    end

    it 'allows scope as attribute' do
      t = 1.day.ago
      scope = Reports::Scope.new(timestamp: t)
      report = Reports::Base.new(scope: scope)
      expect( report.scope ).to eq(scope)
    end
  end

  describe "#timestamp" do
    it "initializes from scope" do
      t = 1.day.ago
      scope = Reports::Scope.new(timestamp: t)
      report = Reports::Base.new(scope: scope)
      expect( report.timestamp ).to eq(t)
    end
  end

  describe "#generate_key" do
    it "on before validate" do
      expect(report).to receive(:generate_key)
      report.valid?
    end

    it "sets key" do
      expect(report.key).to be_blank
      report.generate_key
      expect(report.key).to eq(report.timestamp.to_i.to_s)
    end
  end

  describe "#generate_from_till" do
    it "on before validate" do 
      expect(report).to receive(:generate_from_till)
      report.valid?
    end
  end

  describe "#start_end" do
    it "is not defined" do
      expect{report.start_end}.to raise_error(NameError)
    end
  end

end
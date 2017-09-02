require 'rails_helper'

describe Reports::PerYear do
  let(:report){ Reports::PerYear.new }


  describe ".generate_key" do
    it "sets to at_beginning_of_year" do 
      report.generate_key
      expect(report.key).to eq(report.timestamp.at_beginning_of_year.to_i.to_s)
    end
  end

  describe "#timestamp_for_year" do
    it "validate" do
      report.timestamp = Time.zone.now
      expect(report.valid?).to be_truthy

      report.timestamp = 1.year.ago
      expect(report.valid?).to be_truthy
    end
  end

  describe "#temporary" do
    it "is set by :end" do
      report.timestamp = Time.zone.now
      expect(report.temporary).to be_truthy

      report.timestamp = Time.zone.now.at_beginning_of_year
      expect(report.temporary).to be_truthy

      report.timestamp = Time.zone.now.at_beginning_of_year - 1.second
      expect(report.temporary).to be_falsey
    end
  end

  describe "#start_end" do
    it "is correct" do
      report.timestamp = Time.zone.now.at_beginning_of_year
      expect(report.start_end).to eq({start: Time.zone.now.at_beginning_of_year, end: Time.zone.now.at_end_of_year})

      report.timestamp = Time.zone.now.at_beginning_of_year - 1.second
      expect(report.start_end).to eq({start: Time.zone.now.at_beginning_of_year - 1.year, end: Time.zone.now.at_end_of_year - 1.year})
    end
  end

end
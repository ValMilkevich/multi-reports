require 'rails_helper'

describe Reports::PerDay do
  let(:report){ Reports::PerDay.new }

  describe ".generate_key" do
    it "sets to at_beginning_of_day" do
      report.generate_key
      expect(report.key).to eq(report.timestamp.at_beginning_of_day.to_i.to_s)
    end
  end

  describe "#timestamp_for_day" do
    it "validate" do
      report.timestamp = Time.zone.now
      expect(report.valid?).to be_truthy
    end
  end

  describe "#temporary" do
    it "is set by :end" do
      report.timestamp = Time.zone.now
      expect(report.temporary).to be_truthy

      report.timestamp = Time.zone.now.at_beginning_of_day
      expect(report.temporary).to be_truthy

      report.timestamp = Time.zone.now.at_beginning_of_day - 1.second
      expect(report.temporary).to be_falsey
    end
  end

  describe "#start_end" do
    it "is correct" do
      report.timestamp = Time.zone.now.at_beginning_of_day
      expect(report.start_end).to eq({start: Time.zone.now.at_beginning_of_day, end: Time.zone.now.at_end_of_day})

      report.timestamp = Time.zone.now.at_beginning_of_day - 1.second
      expect(report.start_end).to eq({start: Time.zone.now.at_beginning_of_day - 1.day, end: Time.zone.now.at_end_of_day - 1.day})
    end

    it "is correct for custom interval" do
      CustomReport = Class.new(report.class){self.interval = 1.month}
      report = CustomReport.new
      report.timestamp = Time.zone.now.at_beginning_of_day
      expect(report.start_end).to eq({start: ((report.timestamp - 1.month).at_end_of_day + 1.second).at_beginning_of_day, end: report.timestamp.at_end_of_day})

      report.timestamp = Time.zone.now.at_beginning_of_day - 1.second
      expect(report.start_end).to eq({start: ((report.timestamp - 1.month).at_end_of_day + 1.second).at_beginning_of_day, end: report.timestamp.at_end_of_day })
    end
  end
end
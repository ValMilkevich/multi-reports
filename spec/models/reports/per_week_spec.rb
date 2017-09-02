require 'rails_helper'

describe Reports::PerWeek do
  let(:report){ Reports::PerWeek.new }


  describe ".generate_key" do
    it "sets to at_beginning_of_week" do 
      report.generate_key
      expect(report.key).to eq(report.timestamp.at_beginning_of_week.to_i.to_s)
    end
  end

  describe "#timestamp_for_week" do
    it "validate" do
      report.timestamp = Time.zone.now
      expect(report.valid?).to be_truthy
    end
  end

  describe "#temporary" do
    it "is set by :end" do
      report.timestamp = Time.zone.now
      expect(report.temporary).to be_truthy

      report.timestamp = Time.zone.now.at_beginning_of_week
      expect(report.temporary).to be_truthy

      report.timestamp = Time.zone.now.at_beginning_of_week - 1.second
      expect(report.temporary).to be_falsey
    end
  end

  describe "#start_end" do
    it "is correct" do
      report.timestamp = Time.zone.now.at_beginning_of_week
      expect(report.start_end).to eq({start: Time.zone.now.at_beginning_of_week, end: Time.zone.now.at_end_of_week})

      report.timestamp = Time.zone.now.at_beginning_of_week - 1.second
      expect(report.start_end).to eq({start: Time.zone.now.at_beginning_of_week - 1.week, end: Time.zone.now.at_end_of_week - 1.week})
    end
  end
end

$: << File.join(File.dirname(__FILE__), "..")
require 'test_helper'

describe Webhookr::Recurly::Adapter do
  
  before do
    @valid_response = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <canceled_subscription_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true"></username>
          <email>verena@example.com</email>
          <first_name>Verena</first_name>
          <last_name>Example</last_name>
          <company_name nil="true"></company_name>
        </account>
        <subscription>
          <plan>
            <plan_code>1dpt</plan_code>
            <name>Subscription One</name>
          </plan>
          <uuid>dccd742f4710e78515714d275839f891</uuid>
          <state>canceled</state>
          <quantity type="integer">1</quantity>
          <total_amount_in_cents type="integer">200</total_amount_in_cents>
          <activated_at type="datetime">2010-09-23T22:05:03Z</activated_at>
          <canceled_at type="datetime">2010-09-23T22:05:43Z</canceled_at>
          <expires_at type="datetime">2010-09-24T22:05:03Z</expires_at>
          <current_period_started_at type="datetime">2010-09-23T22:05:03Z</current_period_started_at>
          <current_period_ends_at type="datetime">2010-09-24T22:05:03Z</current_period_ends_at>
          <trial_started_at nil="true" type="datetime"></trial_started_at>
          <trial_ends_at nil="true" type="datetime"></trial_ends_at>
          <collection_method>automatic</collection_method>
        </subscription>
      </canceled_subscription_notification>
    XML
  end

  describe "class" do

    subject { Webhookr::Recurly::Adapter }

    it "must support process" do
      subject.must_respond_to(:process)
    end

    it "should not return an error for a valid payload" do
      lambda {
        subject.process(@valid_response)
      }.must_be_silent
    end

  end

  describe "instance" do
    subject { Webhookr::Recurly::Adapter.new }

    it "should not return an error for a valid packet" do
      lambda {
        subject.process(@valid_response)
      }.must_be_silent
    end

    it "should raise Webhookr::InvalidPayloadError for no data" do
      lambda {
        subject.process("")
      }.must_raise(Webhookr::InvalidPayloadError)
    end

    it "should raise Webhookr::InvalidPayloadError for a missing event type" do
      lambda {
        subject.process("<canceled_subscription_notification />")
      }.must_raise(Webhookr::InvalidPayloadError)
    end

    it "should raise Webhookr::InvalidPayloadError for a missing payload" do
      lambda {
        subject.process("<canceled_subscription_notification />")
      }.must_raise(Webhookr::InvalidPayloadError)
    end

  end

  describe "response" do
    before do
      @adapter = Webhookr::Recurly::Adapter.new
    end

    subject { @adapter.process(@valid_response) }

    it "must respond to service_name" do
      subject.must_respond_to(:service_name)
    end

    it "should return the correct service name" do
      assert_equal(Webhookr::Recurly::Adapter::SERVICE_NAME, subject.service_name)
    end

    it "must respond to event_type" do
      subject.must_respond_to(:event_type)
    end

    it "should return the correct event type" do
      assert_equal("canceled_subscription_notification", subject.event_type)
    end

    it "must respond to payload" do
      subject.must_respond_to(:payload)
    end

    it "should return the correct data" do
      assert_equal("canceled", subject.payload.subscription.state)
    end

    it "should return nested data correctly" do
      assert_equal("Subscription One", subject.payload.subscription.plan.name)
    end

  end

end

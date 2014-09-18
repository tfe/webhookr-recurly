require "webhookr"
require "webhookr-recurly/version"
require "active_support/core_ext/module/attribute_accessors"
require "webhookr/ostruct_utils"

module Webhookr
  module Recurly
    class Adapter
      SERVICE_NAME = 'recurly'

      include Webhookr::Services::Adapter::Base

      def self.process(raw_response)
        new.process(raw_response)
      end

      def process(raw_response)
        response = parse(raw_response)
        event_type, payload = response.first
        Webhookr::AdapterResponse.new(
          SERVICE_NAME,
          event_type,
          OstructUtils.to_ostruct(payload)
        )
      end

      private

      def parse(raw_response)
        assert_valid_packet(
          Hash.from_xml(raw_response)
        )
      end

      def assert_valid_packet(parsed_response)
        raise(Webhookr::InvalidPayloadError,
              "Missing data"
        ) unless parsed_response.present?

        raise(Webhookr::InvalidPayloadError,
              "Missing event key in packet"
        ) unless parsed_response.keys.first.present?

        raise(Webhookr::InvalidPayloadError,
              "No data in the response"
        ) unless parsed_response[parsed_response.keys.first].present?

        parsed_response
      end

    end

  end
end

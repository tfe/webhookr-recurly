$: << File.join(File.dirname(__FILE__), %w{ .. .. })
require 'test_helper'

describe Webhookr::Recurly do
  it "must be defined" do
    Webhookr::Recurly::VERSION.wont_be_nil
  end
end
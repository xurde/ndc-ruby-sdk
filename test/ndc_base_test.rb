require 'test_helper'

class NDCBaseTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Client Base instance initialized wrong" do

    setup do
      @ndc_config = YAML.load_file('test/config/ndc-wrong.yml')
      @ndc_client = NDCClient::Base.new(@ndc_config)
    end

    test "Config is wrong" do
      refute @ndc_client.valid_config?
    end

  end

  describe "Client Base instance initialized OK" do

    setup do
      @ndc_config = YAML.load_file('test/config/ndc-iata-kronos.yml')
      @ndc_client = NDCClient::Base.new(@ndc_config)
    end

    test "Config is OK" do
      assert @ndc_client.valid_config?
    end

    test "Disallow invalid methods" do
      assert_raises(NDCClient::NDCErrors::NDCUnsupportedMethod) {
        @ndc_client.request(:InvalidMethod, {})
      }
    end

  end

end

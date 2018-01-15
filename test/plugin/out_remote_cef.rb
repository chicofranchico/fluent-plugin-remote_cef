require 'test_helper'
require 'fluent/plugin/out_remote_cef'

class RemoteCefOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::RemoteCefOutput).configure(conf)
  end

  def test_configure
    d = create_driver %(
      @type remote_cef
      host 127.0.0.1
      port 1234
      hostname fluentd.example.com
      cef_version "CEF:0"
      device_vendor Ubuntu
      device_product Linux
      device_version 1.0
      signature_id 1000005
    )

    loggers = d.instance.instance_variable_get(:@senders)
    assert_equal loggers, []

    assert_equal 'example.com', d.instance.instance_variable_get(:@host)
    assert_equal 5566, d.instance.instance_variable_get(:@port)
    assert_equal 'debug', d.instance.instance_variable_get(:@severity)
  end

  def test_write
    d = create_driver %(
      @type remote_syslog
      hostname foo.com
      host example.com
      port 5566
      severity debug
      program minitest

      <format>
        @type single_value
        message_key message
      </format>
    )

    mock.proxy(RemoteSyslogSender::UdpSender).new('example.com', 5566, whinyerrors: true, program: 'minitest') do |sender|
      mock.proxy(sender).transmit('foo', facility: 'user', severity: 'debug', program: 'minitest', hostname: 'foo.com')
    end

    d.run do
      d.feed('tag', Fluent::EventTime.now, 'message' => 'foo')
    end
  end
end

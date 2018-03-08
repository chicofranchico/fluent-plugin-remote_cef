require 'cef'

module Fluent
  module Plugin
    # This output plugin implements the sync buffered output mode
    class RemoteCefOutput < Output
      Fluent::Plugin.register_output('remote_cef', self)

      helpers :formatter, :inject

      # overrides the hostname on the log event
      config_param :hostname, :string, default: nil

      config_param :host, :string, default: nil
      config_param :port, :integer, default: 514

      config_param :cef_version, :string, default: 'CEF:0'
      config_param :device_vendor, :string, default: 'fluent'
      config_param :device_product, :string, default: 'fluentd'
      config_param :device_version, :string, default: '1.0'
      config_param :signature_id, :string, default: nil

      config_section :buffer do
        config_set_default :flush_mode, :interval
        config_set_default :flush_interval, 15
        config_set_default :flush_thread_interval, 1
        config_set_default :flush_thread_burst_interval, 1
      end

      config_section :format do
        config_set_default :@type, 'ltsv'
      end

      def initialize
        super
      end

      def configure(conf)
        super
        raise ConfigError, 'host required' if @host.nil?

        @formatter = formatter_create
        unless @formatter.formatter_type == :text_per_line
          raise ConfigError, 'formatter_type must be text_per_line formatter'
        end

        validate_target = "host=#{@host}/port=#{@port}/cef_version=#{@cef_version}/device_vendor=#{@device_vendor}/device_product=#{@device_product}/device_version=#{@device_version}"
        placeholder_validate!(:remote_cef, validate_target)

        @sender = create_sender(@host, @port)
      end

      def close
        super
      end

      def write(chunk)
        return if chunk.empty?

        log.debug 'writing data to file', chunk_id: dump_unique_id_hex(chunk.unique_id)

        begin
          chunk.each do |time, record|
            name = record.key?('message') ? record['message'] : ''

            # instantiate a CEF event
            event = CEF::Event.new(event_time: time.to_int, name: name)

            # for every field, set the corresponding mapped CEF value
            record.each do |k, v|
              event.send(Kernel.format('%s=', k), v)
            end

            # set event defaults after (to enforce them)
            @sender.eventDefaults = {
              host: @hostname,
              cef_version: @cef_version,
              deviceVendor: @device_vendor,
              deviceProduct: @device_product,
              deviceVersion: @device_version,
              deviceEventClassId: @signature_id
            }

            # fire away!
            @sender.emit(event)
          end
        end
      end

      private

      def create_sender(host, port)
        # instantiate an UDP sender object
        sender = CEF::UDPSender.new
        sender.receiver = host
        sender.receiverPort = port
        sender
      end
    end
  end
end

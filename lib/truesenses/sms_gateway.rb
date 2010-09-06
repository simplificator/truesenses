module Truesenses
  class SMSGateway
    RESPONSE_FORMAT = /(\d{2}) (.*)/
    SUCCESS = 1
    HTTP_BASE = 'http://truesenses.com/cgi-bin/smsgateway.cgi'
    HTTPS_BASE = 'https://secure.simmcomm.ch/cgi-bin/smsgateway.cgi'
    include HTTParty

    attr_reader :config



    def initialize(config)
      @config = config
    end

    #
    def credits_left
      post_request('CHECKCREDITS').to_i
    end

    # Send a text message
    #
    # Available options are:
    # :origin: if nil, do not transmit origin even if specified in config
    # :flash: true|false (defaults to false)
    # :test: true|false (defaults to false)
    #
    # returns the ID of the message in the YYMMDDHHMMSS format (strange, i know...)
    def send_text_message(message, receipient, options = {})
      params = {'NUMBER' => receipient, 'MESSAGE' => message}
      if options.has_key?(:origin) && options[:origin].nil?
        # ignore origin, even if it's in config
      elsif options[:origin] || self.config.origin
        # set origin override config is specified in options
        params['ORIGIN'] = options[:origin] || self.config.origin
      end
      params['FLASH'] = 'ON' if options[:flash]
      params['TEST'] = 'ON' if options[:test] || (self.config.deliver == false)
      post_request('SENDMESSAGE', params)
    end




    private

    def post_request(command, options = {})
      parse_response!(SMSGateway.post(base_url, :body => options.merge(default_options).merge({'CMD' => command})))
    end

    def parse_response!(response)
      parsed = RESPONSE_FORMAT.match(response)
      code, message = parsed[1].to_i, parsed[2]
      if code == SUCCESS
        message
      else
        raise SMSGatewayError.new(code, message)
      end
    end


    def default_options
      default_options = {
        'ACCOUNT' => self.config.username,
        'PASSWORD' => self.config.password
      }
    end

    def base_url
      self.config.protocol == :http ? HTTP_BASE : HTTPS_BASE
    end
  end
end
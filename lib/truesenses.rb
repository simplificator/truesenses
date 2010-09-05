require 'rubygems'
require 'httparty'

require 'truesenses/sms_gateway'
require 'truesenses/sms_gateway_error'
require 'truesenses/config'


Truesenses::SMSGateway.new(Truesenses::Config.load('truesenses.yml', 'development')).send_text_message('hallo', '0041763706566')